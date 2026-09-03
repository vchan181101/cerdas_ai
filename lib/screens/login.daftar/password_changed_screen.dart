import 'package:flutter/material.dart';
import '../../values/strings.dart';
import '../../values/colors.dart';
import '../../helpers/helpers.dart';

class PasswordChangedScreen extends StatefulWidget {
  const PasswordChangedScreen({super.key});

  @override
  State<PasswordChangedScreen> createState() => _PasswordChangedScreenState();
}

class _PasswordChangedScreenState extends State<PasswordChangedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController untuk menangani animasi UI
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animasi Pop / Scale Elastis untuk Kontainer Ikon Sukses
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    // Animasi Fade In Lambat untuk Teks dan Tombol
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    );

    // Jalankan animasi saat layar dimuat
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Fungsi Navigasi Kembali ke Login & Bersihkan Stack
  void _navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _navigateToLogin();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),

                // 1. Icon Container Centang Sukses dengan Animasi Pop (Elastic Out)
                Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.emeraldSuccess.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 72,
                          color: AppColors.emeraldSuccess,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Judul Konfirmasi Sukses dengan Animasi Fade In
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    AppStrings.headingPasswordDiubah,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ScreenColorHelper.getHeadingText(context),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Subtitle Pesan dengan Animasi Fade In
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    AppStrings.descPasswordDiubah,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: ScreenColorHelper.getBodyText(context),
                      height: 1.4,
                    ),
                  ),
                ),

                const Spacer(),

                // 4. Tombol Masuk Kembali Gradient dengan Animasi Fade In
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _navigateToLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ScreenColorHelper.getPrimaryAction(context),
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppStrings.btnKembaliLogin.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
