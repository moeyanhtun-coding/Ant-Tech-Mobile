import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_request_entity.dart';
import '../repositories/attendance_repository.dart';

class SubmitAttendanceRequest {
  final AttendanceRepository repository;

  SubmitAttendanceRequest(this.repository);

  Future<Either<Failure, String>> call(AttendanceRequest request) async {
    return await repository.submitAttendanceRequest(request);
  }
}
