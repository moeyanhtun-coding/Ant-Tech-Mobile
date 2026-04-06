import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/utils/globals.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/settings/presentation/bloc/theme_bloc.dart';
import 'features/settings/presentation/bloc/theme_event.dart';
import 'features/settings/presentation/bloc/theme_state.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
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
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => di.sl<HomeBloc>(),
        ),
        BlocProvider<AttendanceBloc>(
          create: (_) => di.sl<AttendanceBloc>(),
        ),
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
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2193b0),
                primary: const Color(0xFF2193b0),
                surface: const Color(0xFFF5F7FB),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                ThemeData.light().textTheme,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4facfe),
                brightness: Brightness.dark,
                surface: const Color(0xFF0F172A),
                primary: const Color(0xFF38BDF8),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                ThemeData.dark().textTheme,
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
