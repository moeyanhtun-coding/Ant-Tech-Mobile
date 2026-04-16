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

  const GetAttendanceRequested({
    required this.employeeGUID,
    required this.month,
  });

  @override
  List<Object?> get props => [employeeGUID, month];
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

  const GetAttendanceRequestsRequested({
    required this.employeeGUID,
    required this.month,
  });

  @override
  List<Object?> get props => [employeeGUID, month];
}

class SubmitAttendanceRequestRequested extends AttendanceEvent {
  final AttendanceRequest request;

  const SubmitAttendanceRequestRequested(this.request);

  @override
  List<Object?> get props => [request];
}
