import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );
  }
}
