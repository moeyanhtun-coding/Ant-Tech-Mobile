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

import 'features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/attendance/domain/usecases/get_attendance_usecase.dart';
import 'features/attendance/domain/usecases/scan_qr_code_usecase.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
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
  // Bloc
  sl.registerFactory(() => AttendanceBloc(
        getAttendanceUseCase: sl(),
        scanQRCodeUseCase: sl(),
      ));
  sl.registerLazySingleton(() => ThemeBloc());

  // Use cases
  sl.registerLazySingleton(() => GetAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => ScanQRCodeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Core
  sl.registerLazySingleton(() => DioClient(sl()));
  
  // External
  sl.registerLazySingleton(() => Dio());
}
