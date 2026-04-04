import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AttendanceEntity>>> getAttendanceByEmployee({
    required String employeeGUID,
    required String month,
  }) async {
    try {
      final records = await remoteDataSource.getAttendanceByEmployee(
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

  @override
  Future<Either<Failure, String>> scanQRCode({
    required String employeeGUID,
    required String locationGUID,
  }) async {
    try {
      final message = await remoteDataSource.scanQRCode(
        employeeGUID: employeeGUID,
        locationGUID: locationGUID,
      );
      return Right(message);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
