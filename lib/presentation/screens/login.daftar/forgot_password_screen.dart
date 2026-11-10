import 'package:flutter/material.dart';
import 'package:cerdas_ai/core/values/values.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Validasi Format Email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Logika Pengiriman Kode OTP
  Future<void> _performSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();

    // Simulasi Delay 2 Detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kode OTP dikirim ke $email')),
    );

    // Navigasi ke Halaman Verifikasi Kode OTP dengan membawa data email
    Navigator.pushReplacementNamed(
      context,
      '/kode-verifikasi',
      arguments: {'email': email},
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    const iconBlue = AppColors.indigoPrimary;
    final inputFill = isDark ? AppDarkColors.white : Colors.white;
    final inputBorderColor = isDark ? AppDarkColors.inputBorder : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: isDark ? AppDarkColors.bgLight : AppColors.bgLight,
      body: BackgroundWrapper(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Top Bar (Tombol Kembali & Judul Terpusat)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: iconBlue),
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                        ),
                      ),
                      Text(
                        'Lupa Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 2. Icon Ilustrasi Kunci Reset dengan Halo Glow Ring sesuai Gambar 1
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (isDark ? const Color(0xFF6366F1) : const Color(0xFFC7D2FE)).withValues(alpha: 0.5),
                            (isDark ? const Color(0xFF8B5CF6) : const Color(0xFFE9D5FF)).withValues(alpha: 0.28),
                            Colors.transparent,
                          ],
                          stops: const [0.55, 0.85, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: isDark ? AppDarkColors.white : AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppDarkColors.inputBorder : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.35 : 0.14),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.lock_reset_rounded,
                              size: 52,
                              color: iconBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 3. Judul & Deskripsi Instruksi
                  Text(
                    'Atur Ulang Kata Sandi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan Email anda untuk reset password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 4. Form Input Email
                  Text(
                    'Email Terdaftar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Masukkan email terdaftar Anda',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.email_outlined, color: iconBlue, size: 20),
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
                      if (!_isValidEmail(value.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // 5. Indikator Pemuatan Loading & Status Teks
                  if (_isLoading)
                    Column(
                      children: [
                        const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: iconBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Mengirim kode verifikasi...',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // 6. Tombol Kirim Kode Verifikasi (Gradien Biru ke Ungu sesuai Gambar 1)
                  AppButton(
                    text: 'Kirim Kode Verifikasi',
                    isLoading: _isLoading,
                    onPressed: _performSendOtp,
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
                  const SizedBox(height: 32),

                  // 7. Footer Kembali Ke Login
                  Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          'Kembali Ke Halaman Login.',
                          style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
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
      ),
    );
  }
}
