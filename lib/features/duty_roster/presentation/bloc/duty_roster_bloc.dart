import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_duty_roster_assignments_usecase.dart';
import 'duty_roster_event.dart';
import 'duty_roster_state.dart';

class DutyRosterBloc extends Bloc<DutyRosterEvent, DutyRosterState> {
  final GetDutyRosterAssignmentsUseCase getAssignmentsUseCase;

  DutyRosterBloc({required this.getAssignmentsUseCase})
      : super(DutyRosterInitial()) {
    on<GetDutyRosterAssignmentsRequested>(_onGetAssignmentsRequested);
  }

  Future<void> _onGetAssignmentsRequested(
    GetDutyRosterAssignmentsRequested event,
    Emitter<DutyRosterState> emit,
  ) async {
    emit(DutyRosterLoading());
    final result = await getAssignmentsUseCase(
      employeeGUID: event.employeeGUID,
      month: event.month,
    );
    result.fold(
      (failure) => emit(DutyRosterFailure(failure.message)),
      (assignments) => emit(DutyRosterLoaded(assignments)),
    );
  }
}
