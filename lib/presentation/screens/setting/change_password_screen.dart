import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/core/values/colors.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Logika Eksekusi Simpan Kata Sandi (Konversi dari btnSimpanPassword listener di Java)
  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('USER_PASSWORD') ?? '123456';

    // Opsional: Validasi apakah kata sandi lama sesuai dengan data tersimpan
    if (oldPassword != savedPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi saat ini tidak sesuai'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Simpan Kata Sandi Baru ke SharedPreferences
    await prefs.setString('USER_PASSWORD', newPassword);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kata sandi berhasil diubah!')),
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/setting');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header / Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 24),
                      color: textColor,
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/setting');
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ubah Kata Sandi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Konten Scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // 1. Label & Input Kata Sandi Saat Ini
                        Text(
                          'Kata Sandi Saat Ini',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _oldPasswordController,
                          obscureText: _obscureOldPassword,
                          style: TextStyle(fontSize: 14, color: textColor),
                          decoration: _buildInputDecoration(
                            hint: 'Masukkan kata sandi lama',
                            isObscured: _obscureOldPassword,
                            isDark: isDark,
                            onToggleObscure: () {
                              setState(() {
                                _obscureOldPassword = !_obscureOldPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Masukkan kata sandi lama';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // 2. Label & Input Kata Sandi Baru
                        Text(
                          'Kata Sandi Baru',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: _obscureNewPassword,
                          style: TextStyle(fontSize: 14, color: textColor),
                          decoration: _buildInputDecoration(
                            hint: 'Masukkan kata sandi baru',
                            isObscured: _obscureNewPassword,
                            isDark: isDark,
                            onToggleObscure: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty || value.trim().length < 6) {
                              return 'Kata sandi baru minimal 6 karakter';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // 3. Label & Input Konfirmasi Kata Sandi Baru
                        Text(
                          'Konfirmasi Kata Sandi Baru',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(fontSize: 14, color: textColor),
                          decoration: _buildInputDecoration(
                            hint: 'Ulangi kata sandi baru',
                            isObscured: _obscureConfirmPassword,
                            isDark: isDark,
                            onToggleObscure: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.trim() != _newPasswordController.text.trim()) {
                              return 'Konfirmasi kata sandi tidak cocok';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        // Tombol Simpan Kata Sandi
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: isDark
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF2563EB),
                                      Color(0xFF6366F1),
                                      Color(0xFF8B5CF6),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF2563EB),
                                      Color(0xFF38BDF8),
                                    ],
                                  ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.45 : 0.25),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _savePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Simpan Kata Sandi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Custom Input Decoration dengan Icon Toggle Visibility & Prefix Key Icon
  InputDecoration _buildInputDecoration({
    required String hint,
    required bool isObscured,
    required bool isDark,
    required VoidCallback onToggleObscure,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF64748B) : Colors.black38,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        Icons.key_rounded,
        color: isDark ? const Color(0xFF38BDF8) : AppColors.indigoPrimary,
        size: 20,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: isDark ? const Color(0xFF94A3B8) : AppColors.iconTint,
          size: 20,
        ),
        onPressed: onToggleObscure,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF38BDF8).withValues(alpha: 0.5) : AppColors.inputBorder,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF38BDF8) : AppColors.indigoPrimary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
