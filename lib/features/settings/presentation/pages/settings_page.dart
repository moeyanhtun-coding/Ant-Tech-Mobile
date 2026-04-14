import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/pages/passcode_page.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/network/network_info.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Appearance', colorScheme),
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              'System Default',
              'Follow device settings',
              Icons.brightness_auto_rounded,
              ThemeMode.system,
            ),
            const SizedBox(height: 12),
            _buildThemeOption(
              context,
              'Light Mode',
              'Classic bright theme',
              Icons.light_mode_rounded,
              ThemeMode.light,
            ),
            const SizedBox(height: 12),
            _buildThemeOption(
              context,
              'Dark Mode',
              'Battery saver & easy on eyes',
              Icons.dark_mode_rounded,
              ThemeMode.dark,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Account', colorScheme),
            const SizedBox(height: 16),
            _buildSettingTile(
              'Profile Status',
              'Active',
              Icons.person_pin_rounded,
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              'App Version',
              '1.0.0 (Build 1)',
              Icons.info_outline_rounded,
              colorScheme,
            ),
            const SizedBox(height: 48),
            _buildSectionHeader('Login Actions', colorScheme),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _onPasscodeTileTapped(context),
              child: _buildSettingTile(
                'Offline Passcode',
                'Configure PIN',
                Icons.pin_rounded,
                colorScheme,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('LOGOUT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  void _onPasscodeTileTapped(BuildContext context) async {
    final existingPasscode = await LocalStorage.getOfflinePasscode();
    if (context.mounted) {
      if (existingPasscode != null && existingPasscode.isNotEmpty) {
        _showChangePasscodeDialog(context, existingPasscode);
      } else {
        _showSetPasscodeDialog(context);
      }
    }
  }

  void _showSetPasscodeDialog(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Set Offline Passcode',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter a 4-digit PIN to access your offline dashboard.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '----',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                counterText: '',
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 24, letterSpacing: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              final pin = pinController.text.trim();
              if (pin.length == 4) {
                await LocalStorage.saveOfflinePasscode(pin);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Offline passcode saved successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasscodeDialog(BuildContext context, String oldPasscode) {
    final TextEditingController pinController = TextEditingController();
    bool isOldVerified = false;
    bool hasError = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              isOldVerified ? 'Set New Passcode' : 'Verify Old Passcode',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isOldVerified
                      ? 'Enter your new 4-digit PIN.'
                      : 'Enter your current 4-digit PIN.',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  onChanged: (_) {
                    if (hasError) setState(() => hasError = false);
                  },
                  decoration: InputDecoration(
                    hintText: '----',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    counterText: '',
                    errorText: hasError ? 'Incorrect PIN' : null,
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 24, letterSpacing: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pin = pinController.text.trim();
                  if (pin.length == 4) {
                    if (!isOldVerified) {
                      if (pin == oldPasscode) {
                        setState(() {
                          isOldVerified = true;
                          hasError = false;
                          pinController.clear();
                        });
                      } else {
                        setState(() {
                          hasError = true;
                        });
                      }
                    } else {
                      await LocalStorage.saveOfflinePasscode(pin);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Offline passcode updated successfully.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(
                  isOldVerified ? 'Save' : 'Verify',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onLogout(BuildContext context) async {
    await LocalStorage.clear();
    final isConnected = await di.sl<NetworkInfo>().isConnected;
    final passcode = await LocalStorage.getOfflinePasscode();

    if (context.mounted) {
      if (!isConnected && passcode != null && passcode.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PasscodePage()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onLogout(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary.withValues(alpha: 0.7),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    ThemeMode mode,
  ) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isSelected = state.themeMode == mode;
        final colorScheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return GestureDetector(
          onTap: () {
            context.read<ThemeBloc>().add(ThemeChanged(mode));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05)),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: colorScheme.primary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile(
    String title,
    String value,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    final isDark = colorScheme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
