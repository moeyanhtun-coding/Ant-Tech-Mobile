import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/local_storage.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<AttendanceModel>> getAttendanceByEmployee({
    required String employeeGUID,
    required String month,
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
}
