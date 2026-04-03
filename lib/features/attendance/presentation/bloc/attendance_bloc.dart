import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendance_usecase.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceUseCase getAttendanceUseCase;

  AttendanceBloc({required this.getAttendanceUseCase}) : super(AttendanceInitial()) {
    on<GetAttendanceRequested>(_onGetAttendanceRequested);
  }

  Future<void> _onGetAttendanceRequested(
    GetAttendanceRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await getAttendanceUseCase(GetAttendanceParams(
      employeeGUID: event.employeeGUID,
      month: event.month,
    ));

    result.fold(
      (failure) => emit(AttendanceFailure(message: failure.message)),
      (records) => emit(AttendanceLoaded(records: records)),
    );
  }
}
