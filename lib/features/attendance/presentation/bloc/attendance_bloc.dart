import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendance_usecase.dart';
import '../../domain/usecases/scan_qr_code_usecase.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceUseCase getAttendanceUseCase;
  final ScanQRCodeUseCase scanQRCodeUseCase;

  AttendanceBloc({
    required this.getAttendanceUseCase,
    required this.scanQRCodeUseCase,
  }) : super(AttendanceInitial()) {
    on<GetAttendanceRequested>(_onGetAttendanceRequested);
    on<ScanQRCodeRequested>(_onScanQRCodeRequested);
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

  Future<void> _onScanQRCodeRequested(
    ScanQRCodeRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await scanQRCodeUseCase(ScanQRCodeParams(
      employeeGUID: event.employeeGUID,
      locationGUID: event.locationGUID,
      latitude: event.latitude,
      longitude: event.longitude,
    ));

    result.fold(
      (failure) => emit(ScanQRCodeFailure(message: failure.message)),
      (message) => emit(ScanQRCodeSuccess(message: message)),
    );
  }
}
