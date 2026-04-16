import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_request_entity.dart';
import '../../domain/entities/attendance_summary_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';
import '../models/attendance_request_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  // In-memory cache
  final Map<String, List<AttendanceEntity>> _attendanceCache = {};
  final Map<String, List<AttendanceRequest>> _requestsCache = {};
  final Map<String, AttendanceSummaryEntity> _summaryCache = {};

  AttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AttendanceEntity>>> getAttendanceByEmployee({
    required String employeeGUID,
    required String month,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${employeeGUID}_$month';
    if (!forceRefresh && _attendanceCache.containsKey(cacheKey)) {
      return Right(_attendanceCache[cacheKey]!);
    }

    try {
      final records = await remoteDataSource.getAttendanceByEmployee(
        employeeGUID: employeeGUID,
        month: month,
      );
      _attendanceCache[cacheKey] = records;
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
      // Invalidate cache on scan
      _attendanceCache.clear();
      _summaryCache.clear();
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
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${employeeGUID}_$month';
    if (!forceRefresh && _requestsCache.containsKey(cacheKey)) {
      return Right(_requestsCache[cacheKey]!);
    }

    try {
      final records = await remoteDataSource.getAttendanceRequests(
        employeeGUID: employeeGUID,
        month: month,
      );
      _requestsCache[cacheKey] = records;
      return Right(records);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> submitAttendanceRequest(
    AttendanceRequest request,
  ) async {
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
        attendanceStatus: request.attendanceStatus,
      );
      final message = await remoteDataSource.submitAttendanceRequest(model);
      // Invalidate requests cache
      _requestsCache.clear();
      _summaryCache.clear();
      return Right(message);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceSummaryEntity>> getAttendanceSummary({
    required String employeeGUID,
    required String month,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${employeeGUID}_$month';
    if (!forceRefresh && _summaryCache.containsKey(cacheKey)) {
      return Right(_summaryCache[cacheKey]!);
    }

    try {
      final summary = await remoteDataSource.getAttendanceSummary(
        employeeGUID: employeeGUID,
        month: month,
      );
      _summaryCache[cacheKey] = summary;
      return Right(summary);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
