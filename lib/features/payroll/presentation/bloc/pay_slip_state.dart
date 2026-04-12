import 'package:equatable/equatable.dart';
import '../../domain/entities/pay_slip_entity.dart';

abstract class PaySlipState extends Equatable {
  const PaySlipState();

  @override
  List<Object?> get props => [];
}

class PaySlipInitial extends PaySlipState {}

class PaySlipLoading extends PaySlipState {}

class PaySlipLoaded extends PaySlipState {
  final List<PaySlipEntity> paySlips;

  const PaySlipLoaded(this.paySlips);

  @override
  List<Object?> get props => [paySlips];
}

class PaySlipFailure extends PaySlipState {
  final String message;

  const PaySlipFailure(this.message);

  @override
  List<Object?> get props => [message];
}
