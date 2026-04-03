import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
          ],
        ),
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
                : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                  ? colorScheme.primary 
                  : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.7),
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
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
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
