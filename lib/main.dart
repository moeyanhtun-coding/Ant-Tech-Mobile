import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/globals.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/payroll/presentation/bloc/pay_slip_bloc.dart';
import 'features/duty_roster/presentation/bloc/duty_roster_bloc.dart';
import 'features/settings/presentation/bloc/theme_bloc.dart';
import 'features/settings/presentation/bloc/theme_event.dart';
import 'features/settings/presentation/bloc/theme_state.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'core/bloc/network/network_bloc.dart';
import 'core/bloc/network/network_event.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkBloc>(
          create: (_) => di.sl<NetworkBloc>()..add(NetworkObserve()),
        ),
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<HomeBloc>(create: (_) => di.sl<HomeBloc>()),
        BlocProvider<AttendanceBloc>(create: (_) => di.sl<AttendanceBloc>()),
        BlocProvider<PaySlipBloc>(create: (_) => di.sl<PaySlipBloc>()),
        BlocProvider<DutyRosterBloc>(create: (_) => di.sl<DutyRosterBloc>()),
        BlocProvider<ThemeBloc>(
          create: (_) => di.sl<ThemeBloc>()..add(GetInitialTheme()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'HWD HR Mobile',
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
