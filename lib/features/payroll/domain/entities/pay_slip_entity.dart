import 'package:equatable/equatable.dart';

class PaySlipEntity extends Equatable {
  final String paySlipGUID;
  final String employeeGUID;
  final String employeeName;
  final String departmentName;
  final String employeeTypeName;
  final String salaryMonth;
  final String payPeriod;
  final String paymentDate;
  final int basicSalary;
  final int totalAllowances;
  final int totalDeductions;
  final int netSalary;
  final int presentDays;
  final int lateDays;
  final int earlyLeaveDays;
  final int absentDays;
  final int leaveDays;
  final String? paySlipPath;
  final String? currencySymbol;

  final List<PaySlipEarningEntity> earnings;
  final List<PaySlipDeductionEntity> deductions;

  const PaySlipEntity({
    required this.paySlipGUID,
    required this.employeeGUID,
    required this.employeeName,
    required this.departmentName,
    required this.employeeTypeName,
    required this.salaryMonth,
    required this.payPeriod,
    required this.paymentDate,
    required this.basicSalary,
    required this.totalAllowances,
    required this.totalDeductions,
    required this.netSalary,
    required this.presentDays,
    required this.lateDays,
    required this.earlyLeaveDays,
    required this.absentDays,
    required this.leaveDays,
    this.paySlipPath,
    this.currencySymbol,
    this.earnings = const [],
    this.deductions = const [],
  });

  @override
  List<Object?> get props => [
        paySlipGUID,
        employeeGUID,
        employeeName,
        departmentName,
        employeeTypeName,
        salaryMonth,
        payPeriod,
        paymentDate,
        basicSalary,
        totalAllowances,
        totalDeductions,
        netSalary,
        presentDays,
        lateDays,
        earlyLeaveDays,
        absentDays,
        leaveDays,
        paySlipPath,
        currencySymbol,
        earnings,
        deductions,
      ];
}

class PaySlipEarningEntity extends Equatable {
  final String guid;
  final String earningName;
  final double amount;
  final double percentage;

  const PaySlipEarningEntity({
    required this.guid,
    required this.earningName,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object?> get props => [guid, earningName, amount, percentage];
}

class PaySlipDeductionEntity extends Equatable {
  final String guid;
  final String deductionName;
  final double amount;
  final double percentage;

  const PaySlipDeductionEntity({
    required this.guid,
    required this.deductionName,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object?> get props => [guid, deductionName, amount, percentage];
}
