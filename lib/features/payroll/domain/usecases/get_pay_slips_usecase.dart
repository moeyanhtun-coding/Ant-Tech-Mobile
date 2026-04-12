import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pay_slip_entity.dart';
import '../repositories/pay_slip_repository.dart';

class GetPaySlipsUseCase {
  final PaySlipRepository repository;

  GetPaySlipsUseCase(this.repository);

  Future<Either<Failure, List<PaySlipEntity>>> call({
    required String employeeGUID,
    String? month,
  }) async {
    return await repository.getPaySlipsByEmployee(
      employeeGUID: employeeGUID,
      month: month,
    );
  }
}
