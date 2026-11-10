import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/core/core.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';
import 'package:cerdas_ai/core/values/values.dart';

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final headingColor = textColor;
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final inputFill = isDark ? AppDarkColors.white : Colors.white;
    final inputBorderColor = isDark ? AppDarkColors.inputBorder : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: isDark ? AppDarkColors.bgLight : AppColors.bgLight,
      body: BackgroundWrapper(
        child: Stack(
          children: [
            // Circuit board decoratif lembut di kiri & kanan atas
            Positioned.fill(
              child: CustomPaint(
                painter: TechCircuitPainter(
                  color: isDark
                      ? const Color(0xFF6366F1).withValues(alpha: 0.18)
                      : const Color(0xFF38BDF8).withValues(alpha: 0.32),
                ),
              ),
            ),

            // Quick Settings: 2 Kolom (Tema & Bahasa) di Pojok Kanan Atas Sesuai Desain
            const Positioned(
              top: 14,
              right: 18,
              child: SafeArea(
                child: QuickThemeLanguageBar(),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        // Logo Cerdas AI Lingkaran Sesuai Gambar 1
                        const CerdasAiLogoBadge(size: 110),

                        const SizedBox(height: 16),

                        // App Name Branding: "Cerdas AI" dengan AI gradien ungu-pink
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.brandCerdas,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: headingColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF8B5CF6),
                                  Color(0xFFEC4899),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Text(
                                'AI',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          AppStrings.sloganApp,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: bodyColor,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Form Input Email
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.labelEmail,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 14, color: textColor),
                          decoration: InputDecoration(
                            hintText: 'Masukkan email',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.indigoPrimary,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: inputFill,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: inputBorderColor,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFF3B82F6),
                                width: 1.8,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.8,
                              ),
                            ),
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(fontSize: 14, color: textColor),
                          decoration: InputDecoration(
                            hintText: 'Masukkan password',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.indigoPrimary,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: isDark ? Colors.white70 : const Color(0xFF64748B),
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: inputFill,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: inputBorderColor,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFF3B82F6),
                                width: 1.8,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.8,
                              ),
                            ),
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
                            child: const Text(
                              'Lupa Kata Sandi?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Tombol Masuk Utama (Gradien Biru ke Ungu sesuai referensi)
                        AppButton(
                          text: AppStrings.btnMasuk,
                          isLoading: _isLoading,
                          onPressed: _performLogin,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1D4ED8),
                              Color(0xFF6D28D9),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: 16,
                          height: 50,
                        ),

                        const SizedBox(height: 22),

                        // Divider Social Login
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark ? AppDarkColors.inputBorder : const Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'atau masuk dengan',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: bodyColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark ? AppDarkColors.inputBorder : const Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Tombol Social Login Row: Google & Apple
                        Row(
                          children: [
                            _buildSocialButton(
                              label: AppStrings.btnGoogle,
                              imagePath: 'asset/ic_google.png',
                              iconFallback: Icons.g_mobiledata,
                              onTap: _performGoogleLogin,
                            ),
                            const SizedBox(width: 14),
                            _buildSocialButton(
                              label: AppStrings.btnApple,
                              imagePath: 'asset/ic_ios.png',
                              iconFallback: Icons.apple,
                              onTap: _performAppleLogin,
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        // Footer Navigasi ke Daftar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: TextStyle(fontSize: 13.5, color: bodyColor),
                            ),
                            GestureDetector(
                              onTap: _isLoading ? null : () => context.pushNamed('/daftar'),
                              child: Text(
                                AppStrings.actionDaftar,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEA580C),
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
          ],
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final Color buttonBg = isDark ? AppDarkColors.white : Colors.white;
    final BorderSide borderSide = BorderSide(
      color: isDark ? AppDarkColors.inputBorder : const Color(0xFFCBD5E1),
      width: 1.2,
    );

    return Expanded(
      child: SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: _isLoading ? null : onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: buttonBg,
            side: borderSide,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(iconFallback, color: textColor, size: 22),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
