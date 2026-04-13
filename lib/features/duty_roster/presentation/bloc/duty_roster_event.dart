import 'package:equatable/equatable.dart';

abstract class DutyRosterEvent extends Equatable {
  const DutyRosterEvent();

  @override
  List<Object?> get props => [];
}

class GetDutyRosterAssignmentsRequested extends DutyRosterEvent {
  final String employeeGUID;
  final String? month;

  const GetDutyRosterAssignmentsRequested({
    required this.employeeGUID,
    this.month,
  });

  @override
  List<Object?> get props => [employeeGUID, month];
}
