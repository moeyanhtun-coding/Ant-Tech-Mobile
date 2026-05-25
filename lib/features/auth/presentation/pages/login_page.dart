import 'package:at_hr_mobile/core/bloc/network/network_bloc.dart';
import 'package:at_hr_mobile/core/bloc/network/network_state.dart';
// Note: Assuming app_theme.dart defines AppThemeColors extension as provided previously
import 'package:at_hr_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'passcode_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. We don't need appColors directly if using Material 3 themes properly
    // final appColors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 2. Remove AppBar entirely to match the UI image
      appBar: null,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            // 3. Page will naturally use scaffoldBackgroundColor, no gradient needed
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 4. Update main logo color
                    Icon(
                      Icons.lock_person_rounded,
                      size: 80,
                      color: colorScheme.primary, // Used theme primary color
                    ),
                    const SizedBox(height: 20),
                    // 5. Title uses default text theme color (usually onSurface)
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                            // Using a standard size
                            fontWeight: FontWeight.bold,
                          ) ??
                          GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            // Note: Default text color from theme applied automatically
                          ),
                    ),
                    const SizedBox(height: 40),
                    // 6. Refactored Text Fields to use inputDecorationTheme
                    _buildTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      icon: Icons.person_outline,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter username'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onPasswordToggle: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter password'
                          : null,
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        // 7. Implicitly uses elevatedButtonTheme defined in AppTheme
                        return ElevatedButton(
                          onPressed: _onLogin,
                          child: Text(
                            'LOGIN',
                            style: GoogleFonts.poppins(
                              // elevation/padding/shape from theme
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // 8. Bottom links row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const PasscodePage(),
                              ),
                            );
                          },
                          child: Text(
                            'Offline Mode',
                            style: GoogleFonts.poppins(
                              color: colorScheme
                                  .primary, // Main mode is online, use secondary highlight or standard color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 9. Integrate Offline Chip here instead of in AppBar
                    BlocBuilder<NetworkBloc, NetworkState>(
                      builder: (context, state) {
                        if (state is NetworkFailure) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              // 10. Using defined chip theme + AppThemeColors extension
                              child: Chip(
                                // AppThemeColors used for the specific offline bg color
                                backgroundColor:
                                    context.appColors.offlineChipBackground,
                                side: BorderSide(
                                  color: colorScheme.error.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                label: Text(
                                  'Offline',
                                  style: TextStyle(
                                    // poppins inherited from textTheme default
                                    fontSize: 12,
                                    color: colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Refactored helper to use the standard inputDecorationTheme
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool? isPasswordVisible,
    VoidCallback? onPasswordToggle,
    String? Function(String?)? validator,
  }) {
    // 1. Access theme values needed for icon coloring

    // 2. Remove the surrounding Container as inputDecorationTheme now handles the styling
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !(isPasswordVisible ?? false),
      // 3. Remove hardcoded styles; styles are defined implicitly in textTheme/inputDecorationTheme
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        // HintStyle, Filled, FillColor, Borders defined globally in app_theme.dart
        prefixIcon: Icon(icon), // prefixIconColor applied implicitly by theme
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (isPasswordVisible ?? false)
                      ? Icons.visibility
                      : Icons.visibility_off,
                ), // suffixIconColor applied implicitly by theme
                onPressed: onPasswordToggle,
              )
            : null,
      ),
    );
  }
}
