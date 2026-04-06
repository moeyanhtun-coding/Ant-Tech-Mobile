import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import '../utils/globals.dart';
import '../utils/local_storage.dart';
import '../../features/auth/presentation/pages/login_page.dart';

class DioClient {
  static bool _isSessionDialogShowing = false;
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

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            if (!_isSessionDialogShowing) {
              _isSessionDialogShowing = true;
              
              await LocalStorage.clear();
              
              final context = navigatorKey.currentContext;
              if (context != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Session Expired'),
                      content: const Text('Your session has expired. Please log in again.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _isSessionDialogShowing = false;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
