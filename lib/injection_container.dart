import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_profile_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/payroll/data/datasources/pay_slip_remote_data_source.dart';
import 'features/payroll/data/repositories/pay_slip_repository_impl.dart';
import 'features/payroll/domain/repositories/pay_slip_repository.dart';
import 'features/payroll/domain/usecases/get_pay_slips_usecase.dart';
import 'features/payroll/presentation/bloc/pay_slip_bloc.dart';
import 'features/settings/presentation/bloc/theme_bloc.dart';

final sl = GetIt.instance; // sl is short for Service Locator

Future<void> init() async {
  // Check if already registered to avoid error on hot restart
  if (sl.isRegistered<Dio>()) return;

  // Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Features - Home
  // Bloc
  sl.registerFactory(() => HomeBloc(
        getProfileUseCase: sl(),
        attendanceRepository: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Features - Attendance
  sl.registerFactory(() => AttendanceBloc(
    getAttendanceUseCase: sl(),
    scanQRCodeUseCase: sl(),
  ));
  sl.registerLazySingleton(() => GetAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => ScanQRCodeUseCase(sl()));
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Features - Payroll
  sl.registerFactory(() => PaySlipBloc(getPaySlipsUseCase: sl()));
  sl.registerLazySingleton(() => GetPaySlipsUseCase(sl()));
  sl.registerLazySingleton<PaySlipRepository>(
    () => PaySlipRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PaySlipRemoteDataSource>(
    () => PaySlipRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  sl.registerLazySingleton(() => ThemeBloc());

  // Core
  sl.registerLazySingleton(() => DioClient(sl()));
  
  // External
  sl.registerLazySingleton(() => Dio());
}
