import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';
import '../../values/values.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 1. Logika Login Manual
  Future<void> _performLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _setLoadingState(true);

    // Simulasi Network Call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserName, 'Sandra Bagus Nugroho');
    await prefs.setString(AppConstants.keyUserEmail, _emailController.text.trim());
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);

    _setLoadingState(false);

    if (mounted) {
      context.showSnackBar('Login Berhasil!');
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }

  // 2. Logika Login Google
  Future<void> _performGoogleLogin() async {
    _setLoadingState(true);
    if (mounted) {
      context.showSnackBar(AppStrings.statusMencariAkun);
    }

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    _setLoadingState(false);

    context.showSnackBar('Login Google Berhasil!');
    Navigator.pushReplacementNamed(context, '/login-google');
  }

  // 3. Logika Login Apple / iOS
  Future<void> _performAppleLogin() async {
    _setLoadingState(true);
    if (mounted) {
      context.showSnackBar(AppStrings.statusMencariAkunApple);
    }

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    _setLoadingState(false);

    context.showSnackBar('Login Apple Berhasil!');
    Navigator.pushReplacementNamed(context, '/login-ios');
  }

  /// Helper untuk mengubah status pemuatan secara aman
  void _setLoadingState(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);

    return Scaffold(
      backgroundColor: AppColors.softBlueBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: GradientHelper.modernLightGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  // Logo App dengan Error Handling
                  Image.asset(
                    AppConstants.logoPath,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.psychology_rounded,
                        size: 100,
                        color: headingColor,
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // App Name Branding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.brandCerdas,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: headingColor,
                        ),
                      ),
                      Text(
                        AppStrings.brandAi,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orangeAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    AppStrings.sloganApp,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: bodyColor,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form Input Email
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.labelEmail,
                      style: ScreenStyleHelper.getLabelStyle(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 14, color: headingColor),
                    decoration: ScreenStyleHelper.modernInputDecoration(
                      context: context,
                      hintText: AppStrings.hintEmail,
                      prefixIcon: Icons.email_outlined,
                    ).copyWith(
                      fillColor: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.8),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.trim().isValidEmail) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Form Input Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.labelPassword,
                      style: ScreenStyleHelper.getLabelStyle(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(fontSize: 14, color: headingColor),
                    decoration: ScreenStyleHelper.modernInputDecoration(
                      context: context,
                      hintText: AppStrings.hintPassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: bodyColor.withValues(alpha: 0.5),
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ).copyWith(
                      fillColor: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.8),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      if (value.trim().length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),

                  // Lupa Kata Sandi
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : () => context.pushNamed('/lupa-password'),
                      child: Text(
                        AppStrings.actionLupaPassword,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tombol Masuk Utama
                  AppButton(
                    text: AppStrings.btnMasuk,
                    isLoading: _isLoading,
                    onPressed: _performLogin,
                    backgroundColor: primaryColor,
                  ),

                  const SizedBox(height: 24),

                  // Divider Social Login
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.inputBorder, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          AppStrings.dividerOr,
                          style: TextStyle(fontSize: 12, color: bodyColor.withValues(alpha: 0.6)),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.inputBorder, thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tombol Social Login Row
                  Row(
                    children: [
                      _buildSocialButton(
                        label: AppStrings.btnGoogle,
                        imagePath: 'asset/ic_google.png',
                        iconFallback: Icons.g_mobiledata,
                        onTap: _performGoogleLogin,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        label: AppStrings.btnApple,
                        imagePath: 'asset/ic_ios.png',
                        iconFallback: Icons.apple,
                        onTap: _performAppleLogin,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Footer Navigasi ke Daftar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.promptBelumPunyaAkun,
                        style: TextStyle(fontSize: 14, color: bodyColor),
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : () => context.pushNamed('/daftar'),
                        child: Text(
                          AppStrings.actionDaftar,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required String imagePath,
    required IconData iconFallback,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: _isLoading ? null : onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: ScreenColorHelper.getSurfaceColor(context),
            side: BorderSide(color: AppColors.inputBorder.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(iconFallback, color: ScreenColorHelper.getHeadingText(context), size: 22),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ScreenColorHelper.getHeadingText(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
