import 'package:equatable/equatable.dart';

class AttendanceRequest extends Equatable {
  final String guid;
  final String employeeGUID;
  final String requestDate;
  final String requestTime;
  final double? latitude;
  final double? longitude;
  final String description;
  final String requestType;
  final String status;
  final String? rejectDescription;
  final String? employeeName;
  final String? departmentName;

  const AttendanceRequest({
    required this.guid,
    required this.employeeGUID,
    required this.requestDate,
    required this.requestTime,
    this.latitude,
    this.longitude,
    required this.description,
    required this.requestType,
    required this.status,
    this.rejectDescription,
    this.employeeName,
    this.departmentName,
  });

  @override
  List<Object?> get props => [
        guid,
        employeeGUID,
        requestDate,
        requestTime,
        latitude,
        longitude,
        description,
        requestType,
        status,
        rejectDescription,
        employeeName,
        departmentName,
      ];
}
