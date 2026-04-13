import 'package:equatable/equatable.dart';
import '../../domain/entities/duty_roster_assignment_entity.dart';

abstract class DutyRosterState extends Equatable {
  const DutyRosterState();

  @override
  List<Object?> get props => [];
}

class DutyRosterInitial extends DutyRosterState {}

class DutyRosterLoading extends DutyRosterState {}

class DutyRosterLoaded extends DutyRosterState {
  final List<DutyRosterAssignmentEntity> assignments;

  const DutyRosterLoaded(this.assignments);

  @override
  List<Object?> get props => [assignments];
}

class DutyRosterFailure extends DutyRosterState {
  final String message;

  const DutyRosterFailure(this.message);

  @override
  List<Object?> get props => [message];
}
