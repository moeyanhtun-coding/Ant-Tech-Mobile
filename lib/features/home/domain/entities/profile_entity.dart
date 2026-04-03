import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String employeeGUID;
  final String username;
  final String fullName;
  final String roleName;
  final String departmentName;
  final String? employeeCode;

  const ProfileEntity({
    required this.username,
    required this.fullName,
    required this.roleName,
    required this.departmentName,
    this.employeeCode,
    required this.employeeGUID,
  });

  @override
  List<Object?> get props => [
    username,
    fullName,
    roleName,
    departmentName,
    employeeCode,
  ];
}
