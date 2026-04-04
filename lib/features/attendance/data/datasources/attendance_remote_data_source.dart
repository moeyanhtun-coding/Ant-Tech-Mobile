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
        return data.map((json) => AttendanceModel.fromJson(json)).toList();
      } else {
        throw const ServerFailure('Failed to fetch attendance');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> scanQRCode({
    required String employeeGUID,
    required String locationGUID,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      
      final response = await dio.post(
        '/AttendanceApi/ScanQRCode',
        data: {
          'EmployeeGUID': employeeGUID,
          'LocationGUID': locationGUID,
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
