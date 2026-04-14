import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../../core/utils/local_storage.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_clock_rounded,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Offline Mode',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your 4-digit passcode',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: _hasError ? Border.all(color: Colors.redAccent, width: 2) : null,
              ),
              child: TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                autofocus: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  letterSpacing: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2193b0),
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: _verifyPasscode,
              ),
            ),
            if (_hasError) ...[
              const SizedBox(height: 16),
              Text(
                'Incorrect Passcode',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                ),
              ),
            ],
            const SizedBox(height: 64),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text(
                'Go to Online Login',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
