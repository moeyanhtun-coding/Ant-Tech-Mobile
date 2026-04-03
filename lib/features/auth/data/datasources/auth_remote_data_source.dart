import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.loginEndpoint,
        data: {
          'Username': username,
          'Password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw const ServerFailure('Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerFailure('Invalid credentials');
      }
      throw ServerFailure(e.message ?? 'Network error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
