import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color brandGradientStart;
  final Color brandGradientEnd;
  final Color success;
  final Color warning;
  final Color info;
  final Color error;
  final Color offlineChipBackground;

  const AppThemeColors({
    required this.brandGradientStart,
    required this.brandGradientEnd,
    required this.success,
    required this.warning,
    required this.info,
    required this.error,
    required this.offlineChipBackground,
  });

  static const light = AppThemeColors(
    brandGradientStart: Color(0xFF1296EA),
    brandGradientEnd: Color(0xFF1FB6FF),
    success: Color(0xFF1D9B63),
    warning: Color(0xFFD99A2D),
    info: Color(0xFF2E8EFA),
    error: Color(0xFFD64B4B),
    offlineChipBackground: Color(0xFFFDECEC),
  );

  static const dark = AppThemeColors(
    brandGradientStart: Color(0xFF0F3552),
    brandGradientEnd: Color(0xFF08121C),
    success: Color(0xFF38C88E),
    warning: Color(0xFFF2B84A),
    info: Color(0xFF63BFFF),
    error: Color(0xFFFF7C7C),
    offlineChipBackground: Color(0xFF41222A),
  );

  @override
  AppThemeColors copyWith({
    Color? brandGradientStart,
    Color? brandGradientEnd,
    Color? success,
    Color? warning,
    Color? info,
    Color? error,
    Color? offlineChipBackground,
  }) {
    return AppThemeColors(
      brandGradientStart: brandGradientStart ?? this.brandGradientStart,
      brandGradientEnd: brandGradientEnd ?? this.brandGradientEnd,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      error: error ?? this.error,
      offlineChipBackground:
          offlineChipBackground ?? this.offlineChipBackground,
    );
  }

  @override
  AppThemeColors lerp(
    covariant ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      brandGradientStart: Color.lerp(
        brandGradientStart,
        other.brandGradientStart,
        t,
      )!,
      brandGradientEnd: Color.lerp(
        brandGradientEnd,
        other.brandGradientEnd,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      error: Color.lerp(error, other.error, t)!,
      offlineChipBackground: Color.lerp(
        offlineChipBackground,
        other.offlineChipBackground,
        t,
      )!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appColors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
}

class AppTheme {
  static const Color _lightPrimary = Color(0xFF1296EA);
  static const Color _lightPrimaryContainer = Color(0xFFDDF1FF);
  static const Color _lightSecondary = Color(0xFF1FB6FF);
  static const Color _lightSurface = Color(0xFFF3F9FF);
  static const Color _lightBackground = Color(0xFFEAF4FF);

  static const Color _darkPrimary = Color(0xFF4DB8FF);
  static const Color _darkPrimaryContainer = Color(0xFF0F3552);
  static const Color _darkSecondary = Color(0xFF22A6F2);
  static const Color _darkSurface = Color(0xFF0B1622);
  static const Color _darkBackground = Color(0xFF08121C);

  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _lightPrimary,
          brightness: Brightness.light,
        ).copyWith(
          primary: _lightPrimary,
          onPrimary: Colors.white,
          primaryContainer: _lightPrimaryContainer,
          onPrimaryContainer: const Color(0xFF083454),
          secondary: _lightSecondary,
          onSecondary: Colors.white,
          surface: _lightSurface,
          onSurface: const Color(0xFF132C44),
          error: AppThemeColors.light.error,
          onError: Colors.white,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _lightBackground,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.35)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFF8FBFF), // Softened white
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primaryContainer,
        disabledColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary.withValues(alpha: 0.14),
        secondarySelectedColor: colorScheme.secondary.withValues(alpha: 0.14),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        labelStyle: TextStyle(color: colorScheme.primary),
        secondaryLabelStyle: TextStyle(color: colorScheme.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F7FF), // Subtle blue-tinted white
        hintStyle: GoogleFonts.poppins(color: Colors.white70),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
      ),
      extensions: const [AppThemeColors.light],
    );
  }

  static ThemeData dark() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _darkPrimary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: _darkPrimary,
          onPrimary: const Color(0xFF001F33),
          primaryContainer: _darkPrimaryContainer,
          onPrimaryContainer: const Color(0xFFCFEAFF),
          secondary: _darkSecondary,
          onSecondary: const Color(0xFF00263A),
          surface: _darkSurface,
          onSurface: const Color(0xFFDDEBFA),
          error: AppThemeColors.dark.error,
          onError: const Color(0xFF3D0000),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBackground,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.32),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.55),
        disabledColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary.withValues(alpha: 0.2),
        secondarySelectedColor: colorScheme.secondary.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        secondaryLabelStyle: TextStyle(color: colorScheme.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
      ),
      extensions: const [AppThemeColors.dark],
    );
  }
}
