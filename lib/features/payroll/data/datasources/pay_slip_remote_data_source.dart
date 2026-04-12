import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/local_storage.dart';
import '../models/pay_slip_model.dart';

abstract class PaySlipRemoteDataSource {
  Future<List<PaySlipModel>> getPaySlipsByEmployee({
    required String employeeGUID,
    String? month,
  });
}

class PaySlipRemoteDataSourceImpl implements PaySlipRemoteDataSource {
  final Dio dio;

  PaySlipRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PaySlipModel>> getPaySlipsByEmployee({
    required String employeeGUID,
    String? month,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      
      final response = await dio.get(
        '/PaySlipApi/GetPaySlipsByEmployee',
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
        return data.map((json) => PaySlipModel.fromJson(json)).toList();
      } else {
        throw const ServerFailure('Failed to fetch payslips');
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
