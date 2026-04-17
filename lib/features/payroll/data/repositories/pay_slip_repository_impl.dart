import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/local_storage.dart';
import '../../domain/entities/pay_slip_entity.dart';
import '../../domain/repositories/pay_slip_repository.dart';
import '../datasources/pay_slip_remote_data_source.dart';
import '../models/pay_slip_model.dart';

class PaySlipRepositoryImpl implements PaySlipRepository {
  final PaySlipRemoteDataSource remoteDataSource;

  // In-memory cache
  final Map<String, List<PaySlipEntity>> _paySlipCache = {};

  PaySlipRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PaySlipEntity>>> getPaySlipsByEmployee({
    required String employeeGUID,
    String? month,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${employeeGUID}_${month ?? 'all'}';

    // 1. Try In-memory cache
    if (!forceRefresh && _paySlipCache.containsKey(cacheKey)) {
      return Right(_paySlipCache[cacheKey]!);
    }

    // 2. Try Persistent Local Storage cache
    if (!forceRefresh) {
      final cachedData = await LocalStorage.getCache('${LocalStorage.keyPaySlips}_$cacheKey');
      if (cachedData != null) {
        try {
          final List<dynamic> decoded = json.decode(cachedData);
          final records = decoded.map((item) => PaySlipModel.fromJson(item)).toList();
          _paySlipCache[cacheKey] = records;
          return Right(records);
        } catch (e) {
          // Continue to remote
        }
      }
    }

    try {
      final records = await remoteDataSource.getPaySlipsByEmployee(
        employeeGUID: employeeGUID,
        month: month,
      );
      
      // Update caches
      _paySlipCache[cacheKey] = records;
      final jsonRecords = records.map((e) => (e as PaySlipModel).toJson()).toList();
      await LocalStorage.saveCache('${LocalStorage.keyPaySlips}_$cacheKey', json.encode(jsonRecords));
      
      return Right(records);
    } on ServerFailure catch (e) {
      if (_paySlipCache.containsKey(cacheKey)) {
        return Right(_paySlipCache[cacheKey]!);
      }
      return Left(e);
    } catch (e) {
      if (_paySlipCache.containsKey(cacheKey)) {
        return Right(_paySlipCache[cacheKey]!);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
