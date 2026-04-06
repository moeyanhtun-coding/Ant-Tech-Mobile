import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileRequested extends HomeEvent {}

class GetAttendanceSummaryRequested extends HomeEvent {
  final String employeeGUID;
  final String month;

  const GetAttendanceSummaryRequested({
    required this.employeeGUID,
    required this.month,
  });

  @override
  List<Object?> get props => [employeeGUID, month];
}
