import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_request_entity.dart';
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
  }) : super(const AttendanceState()) {
    on<GetAttendanceRequested>(_onGetAttendanceRequested);
    on<GetAttendanceRequestsRequested>(_onGetAttendanceRequestsRequested);
    on<ScanQRCodeRequested>(_onScanQRCodeRequested);
    on<SubmitAttendanceRequestRequested>(_onSubmitAttendanceRequestRequested);
    on<FetchAllAttendanceDataRequested>(_onFetchAllAttendanceDataRequested);
  }

  Future<void> _onFetchAllAttendanceDataRequested(
    FetchAllAttendanceDataRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingRecords: true,
      isLoadingRequests: true,
      error: null,
    ));

    final results = await Future.wait([
      getAttendanceUseCase(GetAttendanceParams(
        employeeGUID: event.employeeGUID,
        month: event.month,
        forceRefresh: event.forceRefresh,
      )),
      getAttendanceRequests(
        employeeGUID: event.employeeGUID,
        month: event.month,
        forceRefresh: event.forceRefresh,
      ),
    ]);

    final recordResult = results[0] as Either<Failure, List<AttendanceEntity>>;
    final requestResult = results[1] as Either<Failure, List<AttendanceRequest>>;

    AttendanceState newState = state.copyWith(
      isLoadingRecords: false,
      isLoadingRequests: false,
    );

    recordResult.fold(
      (failure) => newState = newState.copyWith(error: failure.message),
      (records) => newState = newState.copyWith(records: records),
    );

    requestResult.fold(
      (failure) => newState = newState.copyWith(error: failure.message),
      (requests) => newState = newState.copyWith(requests: requests),
    );

    emit(newState);
  }

  Future<void> _onGetAttendanceRequested(
    GetAttendanceRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isLoadingRecords: true));

    final result = await getAttendanceUseCase(GetAttendanceParams(
      employeeGUID: event.employeeGUID,
      month: event.month,
      forceRefresh: event.forceRefresh,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingRecords: false,
        error: failure.message,
      )),
      (records) => emit(state.copyWith(
        isLoadingRecords: false,
        records: records,
      )),
    );
  }

  Future<void> _onGetAttendanceRequestsRequested(
    GetAttendanceRequestsRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isLoadingRequests: true));

    final result = await getAttendanceRequests(
      employeeGUID: event.employeeGUID,
      month: event.month,
      forceRefresh: event.forceRefresh,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingRequests: false,
        error: failure.message,
      )),
      (requests) => emit(state.copyWith(
        isLoadingRequests: false,
        requests: requests,
      )),
    );
  }

  Future<void> _onScanQRCodeRequested(
    ScanQRCodeRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isLoadingRecords: true)); // Or keep current loading state

    final result = await scanQRCodeUseCase(ScanQRCodeParams(
      employeeGUID: event.employeeGUID,
      locationGUID: event.locationGUID,
      latitude: event.latitude,
      longitude: event.longitude,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingRecords: false,
        qrScanError: failure.message,
        qrScanMessage: null,
      )),
      (message) => emit(state.copyWith(
        isLoadingRecords: false,
        qrScanMessage: message,
        qrScanError: null,
      )),
    );
  }

  Future<void> _onSubmitAttendanceRequestRequested(
    SubmitAttendanceRequestRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isLoadingRequests: true));

    final result = await submitAttendanceRequest(event.request);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingRequests: false,
        submitRequestError: failure.message,
        submitRequestMessage: null,
      )),
      (message) => emit(state.copyWith(
        isLoadingRequests: false,
        submitRequestMessage: message,
        submitRequestError: null,
      )),
    );
  }
}
