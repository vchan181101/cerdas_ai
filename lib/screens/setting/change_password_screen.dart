import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../values/colors.dart';

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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header / Top Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      color: AppColors.textPrimary,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/setting');
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Ubah Kata Sandi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 1. Label & Input Kata Sandi Saat Ini
                const Text(
                  'Kata Sandi Saat Ini',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _obscureOldPassword,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                  decoration: _buildInputDecoration(
                    hint: 'Masukkan kata sandi lama',
                    isObscured: _obscureOldPassword,
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

                const SizedBox(height: 16),

                // 2. Label & Input Kata Sandi Baru
                const Text(
                  'Kata Sandi Baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                  decoration: _buildInputDecoration(
                    hint: 'Masukkan kata sandi baru',
                    isObscured: _obscureNewPassword,
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

                const SizedBox(height: 16),

                // 3. Label & Input Konfirmasi Kata Sandi Baru
                const Text(
                  'Konfirmasi Kata Sandi Baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                  decoration: _buildInputDecoration(
                    hint: 'Ulangi kata sandi baru',
                    isObscured: _obscureConfirmPassword,
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
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _savePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.indigoPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Simpan Kata Sandi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Custom Input Decoration dengan Icon Toggle Visibility
  InputDecoration _buildInputDecoration({
    required String hint,
    required bool isObscured,
    required VoidCallback onToggleObscure,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.iconTint, fontSize: 14),
      suffixIcon: IconButton(
        icon: Icon(
          isObscured ? Icons.visibility_off : Icons.visibility,
          color: AppColors.iconTint,
        ),
        onPressed: onToggleObscure,
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.all(14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.indigoPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}