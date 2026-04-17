import 'package:equatable/equatable.dart';

abstract class PaySlipEvent extends Equatable {
  const PaySlipEvent();

  @override
  List<Object?> get props => [];
}

class GetPaySlipsRequested extends PaySlipEvent {
  final String employeeGUID;
  final String? month;
  final bool forceRefresh;

  const GetPaySlipsRequested({
    required this.employeeGUID,
    this.month,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [employeeGUID, month, forceRefresh];
}
