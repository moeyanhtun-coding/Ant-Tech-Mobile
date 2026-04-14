import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/local_storage.dart';
import '../models/duty_roster_assignment_model.dart';

abstract class DutyRosterRemoteDataSource {
  Future<List<DutyRosterAssignmentModel>> getAssignmentsByEmployee({
    required String employeeGUID,
    String? month,
  });
}

class DutyRosterRemoteDataSourceImpl implements DutyRosterRemoteDataSource {
  final Dio dio;

  DutyRosterRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DutyRosterAssignmentModel>> getAssignmentsByEmployee({
    required String employeeGUID,
    String? month,
  }) async {
    final cacheKey = month != null ? 'CACHE_DUTY_ROSTER_$month' : 'CACHE_DUTY_ROSTER_ALL';
    try {
      final token = await LocalStorage.getToken();

      final response = await dio.get(
        '/DutyRosterApi/GetAssignmentsByEmployee',
        queryParameters: {
          'employeeGUID': employeeGUID,
          if (month != null) 'month': month,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        await LocalStorage.saveCache(cacheKey, jsonEncode(data));
        return data
            .map((json) => DutyRosterAssignmentModel.fromJson(json))
            .toList();
      } else {
        throw const ServerFailure('Failed to fetch duty roster assignments');
      }
    } on DioException catch (e) {
      final cachedStr = await LocalStorage.getCache(cacheKey);
      if (cachedStr != null) {
        try {
          final List<dynamic> data = jsonDecode(cachedStr);
          return data.map((json) => DutyRosterAssignmentModel.fromJson(json)).toList();
        } catch (_) {}
      }
      if (e.response != null && e.response!.data != null) {
        throw ServerFailure(
            e.response!.data['message'] ?? 'Network error');
      }
      throw ServerFailure(e.message ?? 'Network error');
    } catch (e) {
      final cachedStr = await LocalStorage.getCache(cacheKey);
      if (cachedStr != null) {
        try {
          final List<dynamic> data = jsonDecode(cachedStr);
          return data.map((json) => DutyRosterAssignmentModel.fromJson(json)).toList();
        } catch (_) {}
      }
      throw ServerFailure(e.toString());
    }
  }
}

