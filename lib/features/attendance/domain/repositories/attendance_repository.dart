import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_entity.dart';
import '../entities/attendance_request_entity.dart';
import '../../domain/entities/attendance_summary_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AttendanceEntity>>> getAttendanceByEmployee({
    required String employeeGUID,
    required String month,
    bool forceRefresh = false,
  });

  Future<Either<Failure, String>> scanQRCode({
    required String employeeGUID,
    required String locationGUID,
    double? latitude,
    double? longitude,
  });

  Future<Either<Failure, List<AttendanceRequest>>> getAttendanceRequests({
    required String employeeGUID,
    required String month,
    bool forceRefresh = false,
  });

  Future<Either<Failure, String>> submitAttendanceRequest(AttendanceRequest request);

  Future<Either<Failure, AttendanceSummaryEntity>> getAttendanceSummary({
    required String employeeGUID,
    required String month,
    bool forceRefresh = false,
  });
}
