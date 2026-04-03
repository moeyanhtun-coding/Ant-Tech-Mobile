import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class GetAttendanceRequested extends AttendanceEvent {
  final String employeeGUID;
  final String month;

  const GetAttendanceRequested({
    required this.employeeGUID,
    required this.month,
  });

  @override
  List<Object?> get props => [employeeGUID, month];
}
