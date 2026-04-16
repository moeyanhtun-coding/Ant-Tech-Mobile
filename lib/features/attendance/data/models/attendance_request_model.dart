import 'package:at_hr_mobile/features/attendance/domain/entities/attendance_request_entity.dart';

class AttendanceRequestModel extends AttendanceRequest {
  const AttendanceRequestModel({
    required super.guid,
    required super.employeeGUID,
    required super.requestDate,
    required super.requestTime,
    super.latitude,
    super.longitude,
    required super.description,
    required super.requestType,
    required super.attendanceStatus,
    super.rejectDescription,
    super.employeeName,
    super.departmentName,
  });

  factory AttendanceRequestModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRequestModel(
      guid: json['guid'] ?? '',
      employeeGUID: json['employeeGUID'] ?? '',
      requestDate: json['requestDate'] ?? '',
      requestTime: json['requestTime'] ?? '',
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      description: json['description'] ?? '',
      requestType: json['requestType'] ?? '',
      attendanceStatus: json['attendanceStatus'] ?? '',
      rejectDescription: json['rejectDescription'],
      employeeName: json['employeeName'],
      departmentName: json['departmentName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'employeeGUID': employeeGUID,
      'requestDate': requestDate,
      'requestTime': requestTime,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'requestType': requestType,
      'attendanceStatus': attendanceStatus,
      'rejectDescription': rejectDescription,
    };
  }
}
