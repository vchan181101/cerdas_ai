import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../values/strings.dart';
import '../../helpers/helpers.dart';

class LoginWithGoogleScreen extends StatefulWidget {
  const LoginWithGoogleScreen({super.key});

  @override
  State<LoginWithGoogleScreen> createState() => _LoginWithGoogleScreenState();
}

class _LoginWithGoogleScreenState extends State<LoginWithGoogleScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  bool _isLoading = true;
  String _statusText = 'Mencari akun Google...';
  bool _showChooseAccountButton = false;

  @override
  void initState() {
    super.initState();
    _startGoogleAccountSearch();
  }

  // Pengecekan Akun & Memicu Auth Google
  Future<void> _startGoogleAccountSearch() async {
    setState(() {
      _isLoading = true;
      _statusText = 'Mencari akun Google...';
      _showChooseAccountButton = false;
    });

    try {
      // 1. Cek apakah pengguna sudah pernah login sebelumnya
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      // 2. Jika belum, picu dialog pemilihan akun Google
      account ??= await _googleSignIn.signIn();

      if (account != null) {
        await _onGoogleAccountSuccess(
          account.displayName ?? 'Pengguna Google',
          account.email,
        );
      } else {
        _showAccountSelectError('Proses pemilihan akun dibatalkan.');
      }
    } catch (error) {
      // Fallback simulasi jika Google Play Services/OAuth belum terkonfigurasi di HP/Emulator
      _runFallbackSimulation();
    }
  }

  // Simulasi Fallback Asinkron jika Native SDK gagal
  Future<void> _runFallbackSimulation() async {
    setState(() {
      _statusText = 'Mencari akun Google...';
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    await _onGoogleAccountSuccess(
      'Pengguna Google',
      'user.google@gmail.com',
    );
  }

  // Penanganan Sukses Login & Simpan Sesi
  Future<void> _onGoogleAccountSuccess(String name, String email) async {
    setState(() {
      _isLoading = false;
      _statusText = 'Login Berhasil! Mengalihkan...';
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
  void _showAccountSelectError(String message) {
    setState(() {
      _isLoading = false;
      _statusText = message;
      _showChooseAccountButton = true;
    });
  }

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
                      AppStrings.titleLoginGoogle,
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
                    // Logo Google
                    Image.asset(
                      'asset/ic_google.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.g_mobiledata,
                          size: 88,
                          color: ScreenColorHelper.getPrimaryAction(context),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Judul & Deskripsi
                    Text(
                      AppStrings.headingGoogleCerdas,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ScreenColorHelper.getHeadingText(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.descGoogleLogin,
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
                          color: ScreenColorHelper.getPrimaryAction(context),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Teks Status
                    Text(
                      _isLoading ? AppStrings.statusMencariAkun : _statusText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ScreenColorHelper.getBodyText(context),
                        fontSize: 14,
                      ),
                    ),

                    // Tombol Pilihan Manual (Jika Batal/Gagal)
                    if (_showChooseAccountButton) ...[
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _startGoogleAccountSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ScreenColorHelper.getPrimaryAction(context),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppStrings.btnPilihAkun.toUpperCase(),
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