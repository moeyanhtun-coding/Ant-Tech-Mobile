import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.username,
    required super.fullName,
    required super.roleName,
    required super.departmentName,
    super.employeeCode,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      username: json['systemUserName'] ?? '',
      fullName: json['fullName'] ?? '',
      roleName: json['roleName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      employeeCode: json['employeeCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systemUserName': username,
      'fullName': fullName,
      'roleName': roleName,
      'departmentName': departmentName,
      'employeeCode': employeeCode,
    };
  }
}
