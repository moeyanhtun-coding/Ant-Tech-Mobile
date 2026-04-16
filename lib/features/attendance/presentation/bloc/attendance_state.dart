import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_request_entity.dart';

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

class ScanQRCodeSuccess extends AttendanceState {
  final String message;

  const ScanQRCodeSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ScanQRCodeFailure extends AttendanceState {
  final String message;

  const ScanQRCodeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AttendanceRequestsLoading extends AttendanceState {}

class AttendanceRequestsLoaded extends AttendanceState {
  final List<AttendanceRequest> requests;

  const AttendanceRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class AttendanceRequestSubmitSuccess extends AttendanceState {
  final String message;

  const AttendanceRequestSubmitSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AttendanceRequestSubmitFailure extends AttendanceState {
  final String message;

  const AttendanceRequestSubmitFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
