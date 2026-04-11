import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final String date;
  final String fullName;
  final String? checkInTime;
  final String? checkOutTime;
  final String? totalHours;
  final String attendanceStatus;
  final String? avatarUrl;
  final String? shiftName;
  final String? scheduledStart;
  final String? scheduledEnd;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;

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
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
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
    checkInLatitude,
    checkInLongitude,
    checkOutLatitude,
    checkOutLongitude,
  ];
}
