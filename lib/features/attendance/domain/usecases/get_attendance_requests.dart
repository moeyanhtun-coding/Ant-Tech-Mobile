import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_request_entity.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceRequests {
  final AttendanceRepository repository;

  GetAttendanceRequests(this.repository);

  Future<Either<Failure, List<AttendanceRequest>>> call({
    required String employeeGUID,
    required String month,
    bool forceRefresh = false,
  }) async {
    return await repository.getAttendanceRequests(
      employeeGUID: employeeGUID,
      month: month,
      forceRefresh: forceRefresh,
    );
  }
}
