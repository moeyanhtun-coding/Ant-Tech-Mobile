import '../../domain/entities/pay_slip_entity.dart';

class PaySlipModel extends PaySlipEntity {
  const PaySlipModel({
    required super.paySlipGUID,
    required super.employeeGUID,
    required super.employeeName,
    required super.departmentName,
    required super.employeeTypeName,
    required super.salaryMonth,
    required super.payPeriod,
    required super.paymentDate,
    required super.basicSalary,
    required super.totalAllowances,
    required super.totalDeductions,
    required super.netSalary,
    required super.presentDays,
    required super.lateDays,
    required super.earlyLeaveDays,
    required super.absentDays,
    required super.leaveDays,
    super.paySlipPath,
    super.currencySymbol,
    super.earnings,
    super.deductions,
  });

  factory PaySlipModel.fromJson(Map<String, dynamic> json) {
    return PaySlipModel(
      paySlipGUID: json['paySlipGUID'] ?? '',
      employeeGUID: json['employeeGUID'] ?? '',
      employeeName: json['employeeName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      employeeTypeName: json['employeeTypeName'] ?? '',
      salaryMonth: json['salaryMonth'] ?? '',
      payPeriod: json['payPeriod'] ?? '',
      paymentDate: json['paymentDate'] ?? '',
      basicSalary: json['basicSalary'] ?? 0,
      totalAllowances: json['totalAllowances'] ?? 0,
      totalDeductions: json['totalDeductions'] ?? 0,
      netSalary: json['netSalary'] ?? 0,
      presentDays: json['presentDays'] ?? 0,
      lateDays: json['lateDays'] ?? 0,
      earlyLeaveDays: json['earlyLeaveDays'] ?? 0,
      absentDays: json['absentDays'] ?? 0,
      leaveDays: json['leaveDays'] ?? 0,
      paySlipPath: json['paySlipPath'],
      currencySymbol: json['currencySymbol'],
      earnings: (json['earningList'] as List<dynamic>?)
              ?.map((e) => PaySlipEarningModel.fromJson(e))
              .toList() ??
          const [],
      deductions: (json['deductionList'] as List<dynamic>?)
              ?.map((e) => PaySlipDeductionModel.fromJson(e))
              .toList() ??
          const [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'paySlipGUID': paySlipGUID,
      'employeeGUID': employeeGUID,
      'employeeName': employeeName,
      'departmentName': departmentName,
      'employeeTypeName': employeeTypeName,
      'salaryMonth': salaryMonth,
      'payPeriod': payPeriod,
      'paymentDate': paymentDate,
      'basicSalary': basicSalary,
      'totalAllowances': totalAllowances,
      'totalDeductions': totalDeductions,
      'netSalary': netSalary,
      'presentDays': presentDays,
      'lateDays': lateDays,
      'earlyLeaveDays': earlyLeaveDays,
      'absentDays': absentDays,
      'leaveDays': leaveDays,
      'paySlipPath': paySlipPath,
      'currencySymbol': currencySymbol,
      'earningList':
          earnings.map((e) => (e as PaySlipEarningModel).toJson()).toList(),
      'deductionList':
          deductions.map((e) => (e as PaySlipDeductionModel).toJson()).toList(),
    };
  }
}

class PaySlipEarningModel extends PaySlipEarningEntity {
  const PaySlipEarningModel({
    required super.guid,
    required super.earningName,
    required super.amount,
    required super.percentage,
  });

  factory PaySlipEarningModel.fromJson(Map<String, dynamic> json) {
    return PaySlipEarningModel(
      guid: json['guid'] ?? '',
      earningName: json['earningName'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'earningName': earningName,
      'amount': amount,
      'percentage': percentage,
    };
  }
}

class PaySlipDeductionModel extends PaySlipDeductionEntity {
  const PaySlipDeductionModel({
    required super.guid,
    required super.deductionName,
    required super.amount,
    required super.percentage,
  });

  factory PaySlipDeductionModel.fromJson(Map<String, dynamic> json) {
    return PaySlipDeductionModel(
      guid: json['guid'] ?? '',
      deductionName: json['deductionName'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'deductionName': deductionName,
      'amount': amount,
      'percentage': percentage,
    };
  }
}
