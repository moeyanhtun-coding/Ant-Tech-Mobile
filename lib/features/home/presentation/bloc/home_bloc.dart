import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../../duty_roster/domain/usecases/get_duty_roster_assignments_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../attendance/domain/entities/attendance_entity.dart';
import '../../../attendance/domain/entities/attendance_request_entity.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProfileUseCase getProfileUseCase;
  final AttendanceRepository attendanceRepository;
  final GetDutyRosterAssignmentsUseCase getDutyRosterAssignmentsUseCase;

  HomeBloc({
    required this.getProfileUseCase,
    required this.attendanceRepository,
    required this.getDutyRosterAssignmentsUseCase,
  }) : super(HomeInitial()) {
    on<GetProfileRequested>(_onGetProfileRequested);
    on<GetAttendanceSummaryRequested>(_onGetAttendanceSummaryRequested);
    on<GetTodayDutyAssignmentRequested>(_onGetTodayDutyAssignmentRequested);
  }

  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final result = await getProfileUseCase(NoParams());

    result.fold((failure) => emit(HomeFailure(message: failure.message)), (
      profile,
    ) {
      emit(
        HomeLoaded(
          profile: profile,
          isSummaryLoading: true,
          isDutyLoading: true,
        ),
      );
      // Automatically fetch this month's attendance summary
      final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
      add(
        GetAttendanceSummaryRequested(
          employeeGUID: profile.employeeGUID,
          month: currentMonth,
        ),
      );
      // Automatically fetch today's duty assignment
      add(GetTodayDutyAssignmentRequested(employeeGUID: profile.employeeGUID));
    });
  }

  Future<void> _onGetAttendanceSummaryRequested(
    GetAttendanceSummaryRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    emit(currentState.copyWith(isSummaryLoading: true));

    // Fetch both records and requests in parallel
    final results = await Future.wait([
      attendanceRepository.getAttendanceByEmployee(
        employeeGUID: event.employeeGUID,
        month: event.month,
      ),
      attendanceRepository.getAttendanceRequests(
        employeeGUID: event.employeeGUID,
        month: event.month,
      ),
    ]);

    final recordResult = results[0] as Either<Failure, List<AttendanceEntity>>;
    final requestResult = results[1] as Either<Failure, List<AttendanceRequest>>;

    if (state is! HomeLoaded) return;
    final currentStateAfter = state as HomeLoaded;

    recordResult.fold(
      (failure) {
        emit(currentStateAfter.copyWith(isSummaryLoading: false));
      },
      (records) {
        int present = 0;
        int late = 0;
        int earlyLeft = 0;
        int lateAndEarlyLeft = 0;

        for (final record in records) {
          final status = record.attendanceStatus.trim().toLowerCase();
          if (status == 'present') {
            present++;
          } else if (status == 'late') {
            late++;
          } else if (status == 'early left') {
            earlyLeft++;
          } else if (status == 'late + early left') {
            lateAndEarlyLeft++;
          }
        }

        int pendingCount = 0;
        requestResult.fold(
          (_) => pendingCount = 0,
          (requests) {
            pendingCount = requests.where((r) => r.attendanceStatus == 'Pending').length;
          },
        );

        final monthLabel = DateFormat('MMMM yyyy').format(DateTime.now());
        final summary = AttendanceSummary(
          present: present,
          late: late,
          earlyLeft: earlyLeft,
          lateAndEarlyLeft: lateAndEarlyLeft,
          pendingRequestCount: pendingCount,
          month: monthLabel,
        );

        emit(
          currentStateAfter.copyWith(
            attendanceSummary: summary,
            isSummaryLoading: false,
          ),
        );
      },
    );
  }

  Future<void> _onGetTodayDutyAssignmentRequested(
    GetTodayDutyAssignmentRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    emit(currentState.copyWith(isDutyLoading: true));

    final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    final result = await getDutyRosterAssignmentsUseCase(
      employeeGUID: event.employeeGUID,
      month: currentMonth,
    );

    if (state is! HomeLoaded) return;
    final currentStateAfter = state as HomeLoaded;

    result.fold(
      (failure) {
        emit(currentStateAfter.copyWith(isDutyLoading: false));
      },
      (assignments) {
        try {
          final now = DateTime.now();
          final todayAssignment = assignments.firstWhereOrNull((a) {
            final assignmentDate = DateTime.tryParse(a.workDay);
            if (assignmentDate == null) return false;

            return assignmentDate.year == now.year &&
                assignmentDate.month == now.month &&
                assignmentDate.day == now.day;
          });

          emit(
            currentStateAfter.copyWith(
              todayAssignment: todayAssignment,
              isDutyLoading: false,
            ),
          );
        } catch (e) {
          // Fallback to ensure loading is at least stopped
          emit(currentStateAfter.copyWith(isDutyLoading: false));
        }
      },
    );
  }
}
