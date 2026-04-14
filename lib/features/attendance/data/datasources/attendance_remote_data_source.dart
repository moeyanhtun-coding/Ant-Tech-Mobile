import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/local_storage.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<AttendanceModel>> getAttendanceByEmployee({
    required String employeeGUID,
    required String month,
  });

  Future<String> scanQRCode({
    required String employeeGUID,
    required String locationGUID,
    double? latitude,
    double? longitude,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio dio;

  AttendanceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AttendanceModel>> getAttendanceByEmployee({
    required String employeeGUID,
    required String month,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      
      final response = await dio.get(
        '/AttendanceApi/GetAttendanceByEmployee',
        queryParameters: {
          'employeeGUID': employeeGUID,
          'month': month,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        await LocalStorage.saveCache('CACHE_ATTENDANCE_$month', jsonEncode(data));
        return data.map((json) => AttendanceModel.fromJson(json)).toList();
      } else {
        throw const ServerFailure('Failed to fetch attendance');
      }
    } on DioException catch (e) {
      final cachedStr = await LocalStorage.getCache('CACHE_ATTENDANCE_$month');
      if (cachedStr != null) {
        try {
          final List<dynamic> data = jsonDecode(cachedStr);
          return data.map((json) => AttendanceModel.fromJson(json)).toList();
        } catch (_) {}
      }
      throw ServerFailure(e.message ?? 'Network error');
    } catch (e) {
      final cachedStr = await LocalStorage.getCache('CACHE_ATTENDANCE_$month');
      if (cachedStr != null) {
        try {
          final List<dynamic> data = jsonDecode(cachedStr);
          return data.map((json) => AttendanceModel.fromJson(json)).toList();
        } catch (_) {}
      }
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> scanQRCode({
    required String employeeGUID,
    required String locationGUID,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      
      final response = await dio.post(
        '/AttendanceApi/ScanQRCode',
        data: {
          'EmployeeGUID': employeeGUID,
          'LocationGUID': locationGUID,
          'Latitude': latitude,
          'Longitude': longitude,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure(response.data['message'] ?? 'Check-in failed');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw ServerFailure(e.response!.data['message'] ?? 'Network error');
      }
      throw ServerFailure(e.message ?? 'Network error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
