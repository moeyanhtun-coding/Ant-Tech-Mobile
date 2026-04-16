import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_request_entity.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class GetAttendanceRequested extends AttendanceEvent {
  final String employeeGUID;
  final String month;
  final bool forceRefresh;

  const GetAttendanceRequested({
    required this.employeeGUID,
    required this.month,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [employeeGUID, month, forceRefresh];
}

class ScanQRCodeRequested extends AttendanceEvent {
  final String employeeGUID;
  final String locationGUID;
  final double? latitude;
  final double? longitude;

  const ScanQRCodeRequested({
    required this.employeeGUID,
    required this.locationGUID,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [employeeGUID, locationGUID, latitude, longitude];
}

class GetAttendanceRequestsRequested extends AttendanceEvent {
  final String employeeGUID;
  final String month;
  final bool forceRefresh;

  const GetAttendanceRequestsRequested({
    required this.employeeGUID,
    required this.month,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [employeeGUID, month, forceRefresh];
}

class SubmitAttendanceRequestRequested extends AttendanceEvent {
  final AttendanceRequest request;

  const SubmitAttendanceRequestRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class FetchAllAttendanceDataRequested extends AttendanceEvent {
  final String employeeGUID;
  final String month;
  final bool forceRefresh;

  const FetchAllAttendanceDataRequested({
    required this.employeeGUID,
    required this.month,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [employeeGUID, month, forceRefresh];
}
