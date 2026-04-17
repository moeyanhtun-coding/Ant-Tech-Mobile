import 'package:equatable/equatable.dart';
import '../../domain/entities/pay_slip_entity.dart';

class PaySlipState extends Equatable {
  final bool isLoading;
  final List<PaySlipEntity> paySlips;
  final String? error;

  const PaySlipState({
    this.isLoading = false,
    this.paySlips = const [],
    this.error,
  });

  PaySlipState copyWith({
    bool? isLoading,
    List<PaySlipEntity>? paySlips,
    String? error,
  }) {
    return PaySlipState(
      isLoading: isLoading ?? this.isLoading,
      paySlips: paySlips ?? this.paySlips,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, paySlips, error];
}
