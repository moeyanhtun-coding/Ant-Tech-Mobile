import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/duty_roster_assignment_entity.dart';

abstract class DutyRosterRepository {
  Future<Either<Failure, List<DutyRosterAssignmentEntity>>> getAssignmentsByEmployee({
    required String employeeGUID,
    String? month,
  });
}
