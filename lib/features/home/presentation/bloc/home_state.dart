import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

class AttendanceSummary extends Equatable {
  final int present;
  final int late;
  final int earlyLeft;
  final int lateAndEarlyLeft;
  final String month;

  const AttendanceSummary({
    required this.present,
    required this.late,
    required this.earlyLeft,
    required this.lateAndEarlyLeft,
    required this.month,
  });

  int get total => present + late + earlyLeft + lateAndEarlyLeft;

  @override
  List<Object?> get props => [present, late, earlyLeft, lateAndEarlyLeft, month];
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
  final bool isSummaryLoading;

  const HomeLoaded({
    required this.profile,
    this.attendanceSummary,
    this.isSummaryLoading = false,
  });

  HomeLoaded copyWith({
    ProfileEntity? profile,
    AttendanceSummary? attendanceSummary,
    bool? isSummaryLoading,
  }) {
    return HomeLoaded(
      profile: profile ?? this.profile,
      attendanceSummary: attendanceSummary ?? this.attendanceSummary,
      isSummaryLoading: isSummaryLoading ?? this.isSummaryLoading,
    );
  }

  @override
  List<Object?> get props => [profile, attendanceSummary, isSummaryLoading];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends HomeState {}
