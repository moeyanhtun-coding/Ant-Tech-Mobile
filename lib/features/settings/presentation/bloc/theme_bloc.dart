import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/local_storage.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<GetInitialTheme>(_onGetInitialTheme);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onGetInitialTheme(
    GetInitialTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final themeModeStr = await LocalStorage.getThemeMode();
    if (themeModeStr != null) {
      final mode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeModeStr,
        orElse: () => ThemeMode.system,
      );
      emit(ThemeState(mode));
    }
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await LocalStorage.saveThemeMode(event.themeMode.toString());
    emit(ThemeState(event.themeMode));
  }
}
