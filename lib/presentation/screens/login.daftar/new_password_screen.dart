import 'package:flutter/material.dart';
import 'package:cerdas_ai/core/values/values.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Logika Eksekusi Penyimpanan Password Baru
  Future<void> _performSaveNewPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi Delay 2 Detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kata sandi berhasil diperbarui!')),
    );

    // Navigasi ke Halaman Password Telah Diubah
    Navigator.pushReplacementNamed(context, '/password-telah-diubah');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color bodyColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    const Color iconBlue = AppColors.indigoPrimary;
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
                  // 1. Top Bar / Tombol Kembali & Judul Terpusat
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
                        'Buat Kata Sandi Baru',
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

                  // 2. Icon Ilustrasi Kunci Reset dengan Halo Glow Ring sesuai Gambar 2
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
                            color: isDark ? AppDarkColors.white : Colors.white,
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

                  // 3. Title & Subtitle
                  Text(
                    'Sandi Baru',
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
                    'Buat kata sandi baru yang kuat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 4. Form Input Password Baru
                  Text(
                    'Kata Sandi Baru',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata sandi baru',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: iconBlue, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: isDark ? Colors.white70 : const Color(0xFF64748B),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
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
                        return 'Kata sandi baru tidak boleh kosong';
                      }
                      if (value.trim().length < 6) {
                        return 'Kata sandi minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 5. Form Input Konfirmasi Password Baru
                  Text(
                    'Konfirmasi Kata Sandi Baru',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    enabled: !_isLoading,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Ulangi kata sandi baru Anda',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: iconBlue, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: isDark ? Colors.white70 : const Color(0xFF64748B),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
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
                        return 'Konfirmasi kata sandi tidak boleh kosong';
                      }
                      if (value.trim() != _passwordController.text.trim()) {
                        return 'Konfirmasi kata sandi tidak cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // 6. Indikator Pemuatan (ProgressBar)
                  if (_isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CircularProgressIndicator(color: iconBlue),
                      ),
                    ),

                  // 7. Tombol Simpan Password (Gradien Biru ke Ungu dengan Ikon Gembok sesuai Gambar 2)
                  AppButton(
                    text: 'SIMPAN KATA SANDI',
                    isLoading: _isLoading,
                    icon: Icons.lock_rounded,
                    onPressed: _performSaveNewPassword,
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
