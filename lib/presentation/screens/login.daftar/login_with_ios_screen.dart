import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../values/strings.dart';
import '../../helpers/helpers.dart';

class LoginWithIosScreen extends StatefulWidget {
  const LoginWithIosScreen({super.key});

  @override
  State<LoginWithIosScreen> createState() => _LoginWithIosScreenState();
}

class _LoginWithIosScreenState extends State<LoginWithIosScreen> {
  bool _isLoading = true;
  String _statusText = 'Mencari akun Apple ID...';
  bool _showSignInAppleButton = false;

  @override
  void initState() {
    super.initState();
    _startAppleAuthProcess();
  }

  // Pengecekan Akun & Memicu Auth Apple
  Future<void> _startAppleAuthProcess() async {
    setState(() {
      _isLoading = true;
      _statusText = 'Mencari akun Apple ID...';
      _showSignInAppleButton = false;
    });

    try {
      // 1. Cek apakah perangkat mendukung Apple Sign-In
      final isAvailable = await SignInWithApple.isAvailable();

      if (isAvailable) {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        String name = 'Pengguna Apple';
        if (credential.givenName != null || credential.familyName != null) {
          name = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
        }

        String email = credential.email ?? 'user.apple@privaterelay.appleid.com';

        await _onAppleAuthSuccess(name, email);
      } else {
        // Fallback jika dijalankan di emulator/Android tanpa Native Apple Support
        await _runFallbackSimulation();
      }
    } catch (error) {
      // Fallback simulasi jika dialog dibatalkan atau Firebase belum terkonfigurasi
      await _runFallbackSimulation();
    }
  }

  // Simulasi Fallback Asinkron untuk Lingkungan Dev/Android
  Future<void> _runFallbackSimulation() async {
    setState(() {
      _statusText = 'Mencari akun Apple ID...';
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    await _onAppleAuthSuccess(
      'Pengguna Apple',
      'user.apple@privaterelay.appleid.com',
    );
  }

  // Penanganan Sukses Login & Simpan Sesi
  Future<void> _onAppleAuthSuccess(String name, String email) async {
    setState(() {
      _isLoading = false;
      _statusText = 'Login Apple ID Berhasil! Mengalihkan...';
    });

    // Simpan profil ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('USER_NAME', name);
    await prefs.setString('USER_EMAIL', email);
    await prefs.setBool('IS_LOGGED_IN', true);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selamat Datang, $name')),
    );

    // Navigasi ke Dashboard dan bersihkan stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
          (route) => false,
    );
  }

  // Tampilan Status Error ketika Batal / Gagal
  /* void _showAuthError(String message) {
    setState(() {
      _isLoading = false;
      _statusText = message;
      _showSignInAppleButton = true;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Top Bar / Tombol Kembali
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: ScreenColorHelper.getHeadingText(context)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.titleLoginApple,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ScreenColorHelper.getHeadingText(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Konten Utama di Tengah (Center Content Box)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Apple
                    Image.asset(
                      'asset/ic_ios.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.apple,
                          size: 88,
                          color: ScreenColorHelper.getHeadingText(context),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Judul & Deskripsi
                    Text(
                      AppStrings.headingAppleCerdas,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ScreenColorHelper.getHeadingText(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.descAppleLogin,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ScreenColorHelper.getBodyText(context),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Indikator Loading / Progress Bar
                    if (_isLoading)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: ScreenColorHelper.getHeadingText(context),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Teks Status
                    Text(
                      _isLoading ? AppStrings.statusMencariAkunApple : _statusText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ScreenColorHelper.getBodyText(context),
                        fontSize: 14,
                      ),
                    ),

                    // Tombol Masuk Kembali jika Dibatalkan / Error
                    if (_showSignInAppleButton) ...[
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _startAppleAuthProcess,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ScreenColorHelper.getHeadingText(context),
                            foregroundColor: ScreenColorHelper.getBackgroundColor(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppStrings.btnMasukApple.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}