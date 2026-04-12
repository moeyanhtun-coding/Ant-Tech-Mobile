import 'package:equatable/equatable.dart';
import '../../domain/entities/pay_slip_entity.dart';

abstract class PaySlipEvent extends Equatable {
  const PaySlipEvent();

  @override
  List<Object?> get props => [];
}

class GetPaySlipsRequested extends PaySlipEvent {
  final String employeeGUID;
  final String? month;

  const GetPaySlipsRequested({required this.employeeGUID, this.month});

  @override
  List<Object?> get props => [employeeGUID, month];
}
