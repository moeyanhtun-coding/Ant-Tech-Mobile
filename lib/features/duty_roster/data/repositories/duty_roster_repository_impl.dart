import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/duty_roster_assignment_entity.dart';
import '../../domain/repositories/duty_roster_repository.dart';
import '../datasources/duty_roster_remote_data_source.dart';

class DutyRosterRepositoryImpl implements DutyRosterRepository {
  final DutyRosterRemoteDataSource remoteDataSource;

  DutyRosterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DutyRosterAssignmentEntity>>>
  getAssignmentsByEmployee({
    required String employeeGUID,
    String? month,
  }) async {
    try {
      final records = await remoteDataSource.getAssignmentsByEmployee(
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
