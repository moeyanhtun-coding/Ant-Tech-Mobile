import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.username,
    required super.fullName,
    required super.roleName,
    required super.departmentName,
    super.employeeCode,
    required super.employeeGUID,
    required super.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      username: json['systemUserName'] ?? '',
      fullName: json['fullName'] ?? '',
      roleName: json['roleName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      employeeCode: json['employeeCode'],
      employeeGUID: json['employeeGUID'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systemUserName': username,
      'fullName': fullName,
      'roleName': roleName,
      'departmentName': departmentName,
      'employeeCode': employeeCode,
      'employeeGUID': employeeGUID,
    };
  }
}
