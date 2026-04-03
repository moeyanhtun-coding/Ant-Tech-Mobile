import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_entity.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceEntity> records;

  const AttendanceLoaded({required this.records});

  @override
  List<Object?> get props => [records];
}

class AttendanceFailure extends AttendanceState {
  final String message;

  const AttendanceFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
