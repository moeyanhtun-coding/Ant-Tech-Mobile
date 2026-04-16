import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceParams {
  final String employeeGUID;
  final String month;
  final bool forceRefresh;

  GetAttendanceParams({
    required this.employeeGUID,
    required this.month,
    this.forceRefresh = false,
  });
}

class GetAttendanceUseCase
    implements UseCase<List<AttendanceEntity>, GetAttendanceParams> {
  final AttendanceRepository repository;

  GetAttendanceUseCase(this.repository);

  @override
  Future<Either<Failure, List<AttendanceEntity>>> call(
    GetAttendanceParams params,
  ) async {
    return await repository.getAttendanceByEmployee(
      employeeGUID: params.employeeGUID,
      month: params.month,
      forceRefresh: params.forceRefresh,
    );
  }
}
