import '../../domain/entities/duty_roster_assignment_entity.dart';

class DutyRosterAssignmentModel extends DutyRosterAssignmentEntity {
  const DutyRosterAssignmentModel({
    required super.assignmentGUID,
    required super.dutyRosterGUID,
    required super.employeeGUID,
    required super.shiftGUID,
    required super.workDay,
    required super.shiftName,
    required super.scheduledStart,
    required super.scheduledEnd,
    required super.departmentGUID,
    required super.departmentName,
    required super.rosterYear,
    required super.rosterMonth,
  });

  factory DutyRosterAssignmentModel.fromJson(Map<String, dynamic> json) {
    return DutyRosterAssignmentModel(
      assignmentGUID: json['assignmentGUID'] ?? '',
      dutyRosterGUID: json['dutyRosterGUID'] ?? '',
      employeeGUID: json['employeeGUID'] ?? '',
      shiftGUID: json['shiftGUID'] ?? '',
      workDay: json['workDay'] ?? '',
      shiftName: json['shiftName'] ?? '',
      scheduledStart: json['scheduledStart'] ?? '',
      scheduledEnd: json['scheduledEnd'] ?? '',
      departmentGUID: json['departmentGUID'] ?? '',
      departmentName: json['departmentName'] ?? '',
      rosterYear: json['rosterYear'] ?? 0,
      rosterMonth: json['rosterMonth'] ?? 0,
    );
  }
}
