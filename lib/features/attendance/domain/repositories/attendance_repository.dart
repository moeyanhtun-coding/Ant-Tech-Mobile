import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AttendanceEntity>>> getAttendanceByEmployee({
    required String employeeGUID,
    required String month,
  });

  Future<Either<Failure, String>> scanQRCode({
    required String employeeGUID,
    required String locationGUID,
  });
}
