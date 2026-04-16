import 'package:at_hr_mobile/features/duty_roster/domain/entities/duty_roster_assignment_entity.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

class AttendanceSummary extends Equatable {
  final int present;
  final int late;
  final int earlyLeft;
  final int lateAndEarlyLeft;
  final int pendingRequestCount;
  final String month;

  const AttendanceSummary({
    required this.present,
    required this.late,
    required this.earlyLeft,
    required this.lateAndEarlyLeft,
    required this.pendingRequestCount,
    required this.month,
  });

  int get total => present + late + earlyLeft + lateAndEarlyLeft;

  @override
  List<Object?> get props => [
    present,
    late,
    earlyLeft,
    lateAndEarlyLeft,
    pendingRequestCount,
    month,
  ];
}

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final ProfileEntity profile;
  final AttendanceSummary? attendanceSummary;
  final DutyRosterAssignmentEntity? todayAssignment;
  final bool isSummaryLoading;
  final bool isDutyLoading;

  const HomeLoaded({
    required this.profile,
    this.attendanceSummary,
    this.todayAssignment,
    this.isSummaryLoading = false,
    this.isDutyLoading = false,
  });

  HomeLoaded copyWith({
    ProfileEntity? profile,
    AttendanceSummary? attendanceSummary,
    DutyRosterAssignmentEntity? todayAssignment,
    bool? isSummaryLoading,
    bool? isDutyLoading,
  }) {
    return HomeLoaded(
      profile: profile ?? this.profile,
      attendanceSummary: attendanceSummary ?? this.attendanceSummary,
      todayAssignment: todayAssignment ?? this.todayAssignment,
      isSummaryLoading: isSummaryLoading ?? this.isSummaryLoading,
      isDutyLoading: isDutyLoading ?? this.isDutyLoading,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    attendanceSummary,
    todayAssignment,
    isSummaryLoading,
    isDutyLoading,
  ];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends HomeState {}
