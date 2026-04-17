import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/local_storage.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_request_entity.dart';
import '../../domain/entities/attendance_summary_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';
import '../models/attendance_model.dart';
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
    
    // 1. Try In-memory cache
    if (!forceRefresh && _attendanceCache.containsKey(cacheKey)) {
      return Right(_attendanceCache[cacheKey]!);
    }

    // 2. Try Persistent Local Storage cache (if not forcing refresh)
    if (!forceRefresh) {
      final cachedData = await LocalStorage.getCache('${LocalStorage.keyAttendanceRecords}_$cacheKey');
      if (cachedData != null) {
        try {
          final List<dynamic> decoded = json.decode(cachedData);
          final records = decoded.map((item) => AttendanceModel.fromJson(item)).toList();
          _attendanceCache[cacheKey] = records;
          return Right(records);
        } catch (e) {
          // If decoding fails, continue to remote
        }
      }
    }

    try {
      final records = await remoteDataSource.getAttendanceByEmployee(
        employeeGUID: employeeGUID,
        month: month,
      );
      
      // Update caches
      _attendanceCache[cacheKey] = records;
      final jsonRecords = records.map((e) => (e as AttendanceModel).toJson()).toList();
      await LocalStorage.saveCache('${LocalStorage.keyAttendanceRecords}_$cacheKey', json.encode(jsonRecords));
      
      return Right(records);
    } on ServerFailure catch (e) {
      // If we failed to fetch fresh data but have cached data, return that instead of error
      if (_attendanceCache.containsKey(cacheKey)) {
        return Right(_attendanceCache[cacheKey]!);
      }
      return Left(e);
    } catch (e) {
      if (_attendanceCache.containsKey(cacheKey)) {
        return Right(_attendanceCache[cacheKey]!);
      }
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
      // We don't clear persistent cache here to allow offline viewing of old data, 
      // but maybe we should clear it if we want to force re-fetch after scan?
      // For now, let's keep it for offline resilience.
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

    // 1. Try In-memory cache
    if (!forceRefresh && _requestsCache.containsKey(cacheKey)) {
      return Right(_requestsCache[cacheKey]!);
    }

    // 2. Try Persistent Local Storage cache
    if (!forceRefresh) {
      final cachedData = await LocalStorage.getCache('${LocalStorage.keyAttendanceRequests}_$cacheKey');
      if (cachedData != null) {
        try {
          final List<dynamic> decoded = json.decode(cachedData);
          final records = decoded.map((item) => AttendanceRequestModel.fromJson(item)).toList();
          _requestsCache[cacheKey] = records;
          return Right(records);
        } catch (e) {
          // Continue to remote
        }
      }
    }

    try {
      final records = await remoteDataSource.getAttendanceRequests(
        employeeGUID: employeeGUID,
        month: month,
      );
      
      // Update caches
      _requestsCache[cacheKey] = records;
      final jsonRecords = records.map((e) => (e as AttendanceRequestModel).toJson()).toList();
      await LocalStorage.saveCache('${LocalStorage.keyAttendanceRequests}_$cacheKey', json.encode(jsonRecords));
      
      return Right(records);
    } on ServerFailure catch (e) {
      if (_requestsCache.containsKey(cacheKey)) {
        return Right(_requestsCache[cacheKey]!);
      }
      return Left(e);
    } catch (e) {
      if (_requestsCache.containsKey(cacheKey)) {
        return Right(_requestsCache[cacheKey]!);
      }
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
