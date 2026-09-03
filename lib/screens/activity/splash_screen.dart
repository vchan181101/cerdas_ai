import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_constants.dart';
import '../../helpers/color/color_helper.dart';
import '../../helpers/xml/network_manager_helper.dart';
import '../../values/strings.dart';
import '../../values/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi Controller Animasi Logo (Bounce Effect)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bounceAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.elasticOut,
      ),
    );

    _playBounceAnimation();
    _startSplashProcess();
  }

  void _playBounceAnimation() {
    _animController.reset();
    _animController.forward();
  }

  void _startSplashProcess() {
    // Delay 2 Detik sesuai SPLASH_DELAY
    Timer(const Duration(seconds: 2), () {
      _checkNetworkAndProceed();
    });
  }

  // Alur Pengecekan Jaringan & Navigasi
  Future<void> _checkNetworkAndProceed() async {
    final isConnected = await NetworkManager.isConnected();

    if (!mounted) return;

    if (isConnected) {
      // Cek status login dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('IS_LOGGED_IN') ?? false;

      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Tampilkan Dialog jika tidak ada internet
      _showNoInternetDialog();
    }
  }

  // Dialog Peringatan Jika Internet Mati
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Tidak Ada Koneksi'),
          content: const Text(
            'Aplikasi Cerdas AI membutuhkan koneksi internet. Aktifkan internet lalu coba lagi.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop(); // Keluar Aplikasi
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigoPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _playBounceAnimation();
                _checkNetworkAndProceed();
              },
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: GradientHelper.darkBackgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 1. Container Utama Logo, Nama Brand, dan Slogan (Center)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Cerdas AI dengan Animasi Bounce
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: Image.asset(
                          AppConstants.logoPath,
                          width: 180,
                          height: 180,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.psychology_rounded,
                              size: 140,
                              color: AppColors.tealAccent,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nama Aplikasi (Brand Cerdas + AI)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.brandCerdas,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.brandAi,
                            style: const TextStyle(
                              color: AppColors.tealAccent,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Slogan Application
                      Text(
                        AppStrings.sloganApp,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Progress Indicator & Versi Aplikasi (Bottom)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          color: AppColors.tealAccent,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppStrings.appVersion,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
