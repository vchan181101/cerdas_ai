import 'package:flutter/material.dart';
import '../../values/strings.dart';
import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';

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
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top Bar / Tombol Kembali
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: ScreenColorHelper.getHeadingText(context)),
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      AppStrings.titlePasswordBaru,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ScreenColorHelper.getHeadingText(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 2. Icon Ilustrasi Reset Password
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: ScreenColorHelper.getSurfaceColor(context),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 70,
                      color: ScreenColorHelper.getPrimaryAction(context),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Title & Subtitle
                Text(
                  AppStrings.headingSandiBaru,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ScreenColorHelper.getHeadingText(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.descSandiBaru,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ScreenColorHelper.getBodyText(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),

                // 4. Form Input Password Baru
                Text(
                  AppStrings.labelPasswordBaru,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: ScreenColorHelper.getHeadingText(context)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading,
                  style: TextStyle(color: ScreenColorHelper.getHeadingText(context)),
                  decoration: ScreenStyleHelper.modernInputDecoration(
                    context: context,
                    hintText: AppStrings.hintPasswordBaru,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ).copyWith(
                    fillColor: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.8),
                    filled: true,
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
                  AppStrings.labelKonfirmasiPasswordBaru,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: ScreenColorHelper.getHeadingText(context)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  enabled: !_isLoading,
                  style: TextStyle(color: ScreenColorHelper.getHeadingText(context)),
                  decoration: ScreenStyleHelper.modernInputDecoration(
                    context: context,
                    hintText: AppStrings.hintKonfirmasiPasswordBaru,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ).copyWith(
                    fillColor: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.8),
                    filled: true,
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
                const SizedBox(height: 32),

                // 6. Indikator Pemuatan (ProgressBar)
                if (_isLoading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CircularProgressIndicator(color: ScreenColorHelper.getPrimaryAction(context)),
                    ),
                  ),

                // 7. Tombol Simpan Password
                AppButton(
                  text: AppStrings.btnSimpanPassword.toUpperCase(),
                  isLoading: _isLoading,
                  icon: Icons.save_rounded,
                  onPressed: _performSaveNewPassword,
                  backgroundColor: ScreenColorHelper.getPrimaryAction(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}