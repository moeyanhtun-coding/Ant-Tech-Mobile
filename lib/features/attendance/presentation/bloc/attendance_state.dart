import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_request_entity.dart';

class AttendanceState extends Equatable {
  final List<AttendanceEntity> records;
  final List<AttendanceRequest> requests;
  final bool isLoadingRecords;
  final bool isLoadingRequests;
  final String? error;
  final String? successMessage; 
  final String? qrScanMessage;
  final String? qrScanError;
  final String? submitRequestMessage;
  final String? submitRequestError;

  const AttendanceState({
    this.records = const [],
    this.requests = const [],
    this.isLoadingRecords = false,
    this.isLoadingRequests = false,
    this.error,
    this.successMessage,
    this.qrScanMessage,
    this.qrScanError,
    this.submitRequestMessage,
    this.submitRequestError,
  });

  AttendanceState copyWith({
    List<AttendanceEntity>? records,
    List<AttendanceRequest>? requests,
    bool? isLoadingRecords,
    bool? isLoadingRequests,
    String? error,
    String? successMessage,
    String? qrScanMessage,
    String? qrScanError,
    String? submitRequestMessage,
    String? submitRequestError,
  }) {
    return AttendanceState(
      records: records ?? this.records,
      requests: requests ?? this.requests,
      isLoadingRecords: isLoadingRecords ?? this.isLoadingRecords,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
      qrScanMessage: qrScanMessage ?? this.qrScanMessage,
      qrScanError: qrScanError ?? this.qrScanError,
      submitRequestMessage: submitRequestMessage ?? this.submitRequestMessage,
      submitRequestError: submitRequestError ?? this.submitRequestError,
    );
  }

  @override
  List<Object?> get props => [
        records,
        requests,
        isLoadingRecords,
        isLoadingRequests,
        error,
        successMessage,
        qrScanMessage,
        qrScanError,
        submitRequestMessage,
        submitRequestError,
      ];
}
