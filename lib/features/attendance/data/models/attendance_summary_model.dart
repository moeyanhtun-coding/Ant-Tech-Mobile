import '../../domain/entities/attendance_summary_entity.dart';

class AttendanceSummaryModel extends AttendanceSummaryEntity {
  const AttendanceSummaryModel({
    required super.present,
    required super.late,
    required super.earlyLeft,
    required super.lateAndEarlyLeft,
    required super.pendingRequestCount,
    required super.approvedRequestCount,
    required super.rejectedRequestCount,
    required super.month,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      present: json['present'] ?? 0,
      late: json['late'] ?? 0,
      earlyLeft: json['earlyLeft'] ?? 0,
      lateAndEarlyLeft: json['lateAndEarlyLeft'] ?? 0,
      pendingRequestCount: json['pendingRequestCount'] ?? 0,
      approvedRequestCount: json['approvedRequestCount'] ?? 0,
      rejectedRequestCount: json['rejectedRequestCount'] ?? 0,
      month: json['month'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'present': present,
      'late': late,
      'earlyLeft': earlyLeft,
      'lateAndEarlyLeft': lateAndEarlyLeft,
      'pendingRequestCount': pendingRequestCount,
      'approvedRequestCount': approvedRequestCount,
      'rejectedRequestCount': rejectedRequestCount,
      'month': month,
    };
  }
}
