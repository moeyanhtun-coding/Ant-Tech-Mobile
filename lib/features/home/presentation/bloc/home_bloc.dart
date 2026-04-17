import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../../duty_roster/domain/usecases/get_duty_roster_assignments_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
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

    final result = await attendanceRepository.getAttendanceSummary(
      employeeGUID: event.employeeGUID,
      month: event.month,
    );

    if (state is! HomeLoaded) return;
    final currentStateAfter = state as HomeLoaded;

    result.fold(
      (failure) {
        emit(currentStateAfter.copyWith(isSummaryLoading: false));
      },
      (summaryEntity) {
        // Map the domain entity to the UI model (AttendanceSummary)
        final summary = AttendanceSummary(
          present: summaryEntity.present,
          late: summaryEntity.late,
          earlyLeft: summaryEntity.earlyLeft,
          lateAndEarlyLeft: summaryEntity.lateAndEarlyLeft,
          pendingRequestCount: summaryEntity.pendingRequestCount,
          month: summaryEntity.month,
          approvedRequestCount: summaryEntity.approvedRequestCount,
          rejectedRequestCount: summaryEntity.rejectedRequestCount,
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
