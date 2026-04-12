import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pay_slip_entity.dart';

abstract class PaySlipRepository {
  Future<Either<Failure, List<PaySlipEntity>>> getPaySlipsByEmployee({
    required String employeeGUID,
    String? month,
  });
}
