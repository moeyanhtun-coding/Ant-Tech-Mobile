import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendance_requests.dart';
import '../../domain/usecases/get_attendance_usecase.dart';
import '../../domain/usecases/scan_qr_code_usecase.dart';
import '../../domain/usecases/submit_attendance_request.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceUseCase getAttendanceUseCase;
  final ScanQRCodeUseCase scanQRCodeUseCase;
  final GetAttendanceRequests getAttendanceRequests;
  final SubmitAttendanceRequest submitAttendanceRequest;

  AttendanceBloc({
    required this.getAttendanceUseCase,
    required this.scanQRCodeUseCase,
    required this.getAttendanceRequests,
    required this.submitAttendanceRequest,
  }) : super(AttendanceInitial()) {
    on<GetAttendanceRequested>(_onGetAttendanceRequested);
    on<ScanQRCodeRequested>(_onScanQRCodeRequested);
    on<GetAttendanceRequestsRequested>(_onGetAttendanceRequestsRequested);
    on<SubmitAttendanceRequestRequested>(_onSubmitAttendanceRequestRequested);
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

  Future<void> _onGetAttendanceRequestsRequested(
    GetAttendanceRequestsRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceRequestsLoading());

    final result = await getAttendanceRequests(
      employeeGUID: event.employeeGUID,
      month: event.month,
    );

    result.fold(
      (failure) => emit(AttendanceFailure(message: failure.message)),
      (requests) => emit(AttendanceRequestsLoaded(requests: requests)),
    );
  }

  Future<void> _onSubmitAttendanceRequestRequested(
    SubmitAttendanceRequestRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await submitAttendanceRequest(event.request);

    result.fold(
      (failure) => emit(AttendanceRequestSubmitFailure(message: failure.message)),
      (message) => emit(AttendanceRequestSubmitSuccess(message: message)),
    );
  }
}
