import 'package:equatable/equatable.dart';

class DutyRosterAssignmentEntity extends Equatable {
  final String assignmentGUID;
  final String dutyRosterGUID;
  final String employeeGUID;
  final String shiftGUID;
  final String workDay;
  final String shiftName;
  final String scheduledStart;
  final String scheduledEnd;
  final String departmentGUID;
  final String departmentName;
  final int rosterYear;
  final int rosterMonth;

  const DutyRosterAssignmentEntity({
    required this.assignmentGUID,
    required this.dutyRosterGUID,
    required this.employeeGUID,
    required this.shiftGUID,
    required this.workDay,
    required this.shiftName,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.departmentGUID,
    required this.departmentName,
    required this.rosterYear,
    required this.rosterMonth,
  });

  @override
  List<Object?> get props => [
        assignmentGUID,
        dutyRosterGUID,
        employeeGUID,
        shiftGUID,
        workDay,
        shiftName,
        scheduledStart,
        scheduledEnd,
        departmentGUID,
        departmentName,
        rosterYear,
        rosterMonth,
      ];
}
