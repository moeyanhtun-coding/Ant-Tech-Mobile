import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_request_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';
import '../models/attendance_request_model.dart';

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
    double? latitude,
    double? longitude,
  }) async {
    try {
      final message = await remoteDataSource.scanQRCode(
        employeeGUID: employeeGUID,
        locationGUID: locationGUID,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(message);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRequest>>> getAttendanceRequests({
    required String employeeGUID,
    required String month,
  }) async {
    try {
      final records = await remoteDataSource.getAttendanceRequests(
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
  Future<Either<Failure, String>> submitAttendanceRequest(AttendanceRequest request) async {
    try {
      final model = AttendanceRequestModel(
        guid: request.guid,
        employeeGUID: request.employeeGUID,
        requestDate: request.requestDate,
        requestTime: request.requestTime,
        latitude: request.latitude,
        longitude: request.longitude,
        description: request.description,
        requestType: request.requestType,
        status: request.status,
      );
      final message = await remoteDataSource.submitAttendanceRequest(model);
      return Right(message);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
