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
        return ProfileModel.fromJson(response.data);
      } else {
        throw const ServerFailure('Failed to fetch profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerFailure('Session expired. Please login again.');
      }
      throw ServerFailure(e.message ?? 'Network error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
