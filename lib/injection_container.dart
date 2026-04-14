import 'package:at_hr_mobile/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:at_hr_mobile/features/duty_roster/data/datasources/duty_roster_remote_data_source.dart';
import 'package:at_hr_mobile/features/duty_roster/data/repositories/duty_roster_repository_impl.dart';
import 'package:at_hr_mobile/features/duty_roster/domain/repositories/duty_roster_repository.dart';
import 'package:at_hr_mobile/features/duty_roster/domain/usecases/get_duty_roster_assignments_usecase.dart';
import 'package:at_hr_mobile/features/duty_roster/presentation/bloc/duty_roster_bloc.dart';
import 'package:at_hr_mobile/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:at_hr_mobile/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:at_hr_mobile/features/attendance/domain/usecases/get_attendance_usecase.dart';
import 'package:at_hr_mobile/features/attendance/domain/usecases/scan_qr_code_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/bloc/network/network_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  sl.registerFactory(
    () => HomeBloc(
      getProfileUseCase: sl(),
      attendanceRepository: sl(),
      getDutyRosterAssignmentsUseCase: sl(),
    ),
  );

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
  sl.registerFactory(
    () => AttendanceBloc(getAttendanceUseCase: sl(), scanQRCodeUseCase: sl()),
  );
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

  // Features - Duty Roster
  sl.registerFactory(() => DutyRosterBloc(getAssignmentsUseCase: sl()));
  sl.registerLazySingleton(() => GetDutyRosterAssignmentsUseCase(sl()));
  sl.registerLazySingleton<DutyRosterRepository>(
    () => DutyRosterRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DutyRosterRemoteDataSource>(
    () => DutyRosterRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  sl.registerLazySingleton(() => ThemeBloc());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerFactory(() => NetworkBloc(networkInfo: sl()));
  sl.registerLazySingleton(() => DioClient(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}
