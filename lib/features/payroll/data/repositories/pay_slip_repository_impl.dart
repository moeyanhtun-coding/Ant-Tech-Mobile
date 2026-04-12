import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pay_slip_entity.dart';
import '../../domain/repositories/pay_slip_repository.dart';
import '../datasources/pay_slip_remote_data_source.dart';

class PaySlipRepositoryImpl implements PaySlipRepository {
  final PaySlipRemoteDataSource remoteDataSource;

  PaySlipRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PaySlipEntity>>> getPaySlipsByEmployee({
    required String employeeGUID,
    String? month,
  }) async {
    try {
      final records = await remoteDataSource.getPaySlipsByEmployee(
        employeeGUID: employeeGUID,
        month: month,
      );
      return Right(records);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
