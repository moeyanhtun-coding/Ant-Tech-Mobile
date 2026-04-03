import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final String date;
  final String fullName;
  final String? checkInTime;
  final String? checkOutTime;
  final String? totalHours;
  final String attendanceStatus;
  final String? shiftName;
  final String? scheduledStart;
  final String? scheduledEnd;
  final String? avatarUrl;

  const AttendanceEntity({
    required this.date,
    required this.fullName,
    this.checkInTime,
    this.checkOutTime,
    this.totalHours,
    required this.attendanceStatus,
    this.shiftName,
    this.scheduledStart,
    this.scheduledEnd,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
    date,
    fullName,
    checkInTime,
    checkOutTime,
    totalHours,
    attendanceStatus,
    shiftName,
    scheduledStart,
    scheduledEnd,
    avatarUrl,
  ];
}
