import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProfileUseCase getProfileUseCase;
  final AttendanceRepository attendanceRepository;

  HomeBloc({
    required this.getProfileUseCase,
    required this.attendanceRepository,
  }) : super(HomeInitial()) {
    on<GetProfileRequested>(_onGetProfileRequested);
    on<GetAttendanceSummaryRequested>(_onGetAttendanceSummaryRequested);
  }

  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(HomeFailure(message: failure.message)),
      (profile) {
        emit(HomeLoaded(profile: profile, isSummaryLoading: true));
        // Automatically fetch this month's attendance summary
        final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
        add(GetAttendanceSummaryRequested(
          employeeGUID: profile.employeeGUID,
          month: currentMonth,
        ));
      },
    );
  }

  Future<void> _onGetAttendanceSummaryRequested(
    GetAttendanceSummaryRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final result = await attendanceRepository.getAttendanceByEmployee(
      employeeGUID: event.employeeGUID,
      month: event.month,
    );

    result.fold(
      (failure) {
        // Emit state without summary on failure, but stop loading
        emit(currentState.copyWith(isSummaryLoading: false));
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

        final monthLabel = DateFormat('MMMM yyyy').format(DateTime.now());
        final summary = AttendanceSummary(
          present: present,
          late: late,
          earlyLeft: earlyLeft,
          lateAndEarlyLeft: lateAndEarlyLeft,
          month: monthLabel,
        );

        emit(currentState.copyWith(
          attendanceSummary: summary,
          isSummaryLoading: false,
        ));
      },
    );
  }
}
