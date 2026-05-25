import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../../core/utils/local_storage.dart';
// import 'package:at_hr_mobile/core/theme/app_theme.dart'; // Note: Assuming app_theme.dart defines AppThemeColors extension
import 'login_page.dart';

class PasscodePage extends StatefulWidget {
  const PasscodePage({super.key});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  final TextEditingController _pinController = TextEditingController();
  bool _hasError = false;

  void _verifyPasscode(String value) async {
    if (value.length == 4) {
      final savedPasscode = await LocalStorage.getOfflinePasscode();
      if (savedPasscode == value) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainPage()),
          );
        }
      } else {
        setState(() {
          _hasError = true;
          _pinController.clear();
        });
      }
    } else {
      if (_hasError) {
        setState(() {
          _hasError = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Access theme values. appColors (ThemeExtension) is used for specific chip colors if needed,
    // but the primary values we need are in ColorScheme.
    // final appColors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // 2. Removed the unnecessary surrounding Container. Scaffold uses scaffoldBackgroundColor by default.
      body: SafeArea(
        // Keep content within status bar boundaries
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 3. Icon uses Theme Primary Color
              Icon(
                Icons.lock_clock_rounded,
                size: 80,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 20),
              // 4. Title uses standard TextTheme sizing
              Text(
                'Offline Mode',
                style:
                    textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ) ??
                    textTheme.displaySmall?.copyWith(
                      // fallback for standard layout
                      fontWeight: FontWeight.bold,
                    ) ??
                    GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              // 5. Description uses implicit text theme family and color
              Text(
                'Enter your 4-digit passcode',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              // 6. Integrated input decoration. Container removed.
              // We rely on standard decoration which handles state (error/focus) via defined theme.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  // 7. Styling specific to the large PIN input.
                  // Poppins used explicitly for layout control (letterSpacing)
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    letterSpacing: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '----', // Visual prompt for 4 digits
                    // errorText: _hasError ? 'Incorrect Passcode' : null, // (Optionally move error here)
                  ),
                  onChanged: _verifyPasscode,
                ),
              ),

              // 8. Explicit error message state. Rely on TextTheme default colors.
              if (_hasError) ...[
                const SizedBox(height: 16),
                Text(
                  'Incorrect Passcode',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: 64),
              // 9. TextButton is styled implicitly. Removed hardcoded white text.
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: Text(
                  'Go to Online Login',
                  style: GoogleFonts.poppins(
                    color: colorScheme
                        .primary, // Main mode is online, use secondary highlight or standard color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
