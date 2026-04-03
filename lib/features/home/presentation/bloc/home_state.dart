import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final ProfileEntity profile;

  const HomeLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends HomeState {}
