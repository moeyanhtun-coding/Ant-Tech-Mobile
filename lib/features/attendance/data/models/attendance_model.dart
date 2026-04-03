import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.date,
    required super.fullName,
    super.checkInTime,
    super.checkOutTime,
    super.totalHours,
    required super.attendanceStatus,
    super.shiftName,
    super.scheduledStart,
    super.scheduledEnd,
    super.avatarUrl,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: json['date'] ?? '',
      fullName: json['fullName'] ?? '',
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
      totalHours: json['totalHours'],
      attendanceStatus: json['attendanceStatus'] ?? '',
      shiftName: json['shiftName'],
      scheduledStart: json['scheduledStart'],
      scheduledEnd: json['scheduledEnd'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'fullName': fullName,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'totalHours': totalHours,
      'attendanceStatus': attendanceStatus,
      'shiftName': shiftName,
      'scheduledStart': scheduledStart,
      'scheduledEnd': scheduledEnd,
      'avatarUrl': avatarUrl,
    };
  }
}
