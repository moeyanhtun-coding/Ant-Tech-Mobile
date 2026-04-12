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
    );
  }

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
    };
  }
}
