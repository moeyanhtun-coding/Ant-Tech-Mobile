import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/local_storage.dart';
import '../models/profile_model.dart';

abstract class HomeRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final token = await LocalStorage.getToken();
      
      final response = await dio.get(
        '/ProfileApi',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        await LocalStorage.saveCache('CACHE_PROFILE', jsonEncode(response.data));
        return ProfileModel.fromJson(response.data);
      } else {
        throw const ServerFailure('Failed to fetch profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerFailure('Session expired. Please login again.');
      }
      final cachedStr = await LocalStorage.getCache('CACHE_PROFILE');
      if (cachedStr != null) {
        try {
          return ProfileModel.fromJson(jsonDecode(cachedStr));
        } catch (_) {}
      }
      throw ServerFailure(e.message ?? 'Network error');
    } catch (e) {
      final cachedStr = await LocalStorage.getCache('CACHE_PROFILE');
      if (cachedStr != null) {
        try {
          return ProfileModel.fromJson(jsonDecode(cachedStr));
        } catch (_) {}
      }
      throw ServerFailure(e.toString());
    }
  }
}
