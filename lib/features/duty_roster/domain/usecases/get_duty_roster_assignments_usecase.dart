import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/duty_roster_assignment_entity.dart';
import '../repositories/duty_roster_repository.dart';

class GetDutyRosterAssignmentsUseCase {
  final DutyRosterRepository repository;

  GetDutyRosterAssignmentsUseCase(this.repository);

  Future<Either<Failure, List<DutyRosterAssignmentEntity>>> call({
    required String employeeGUID,
    String? month,
  }) async {
    return await repository.getAssignmentsByEmployee(
      employeeGUID: employeeGUID,
      month: month,
    );
  }
}
