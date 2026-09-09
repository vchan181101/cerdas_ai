import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../values/values.dart';
import '../../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap input field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController = TextEditingController();

  String? _selectedJenisKelamin;
  bool _cbSyaratKetentuan = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _genderList = ['Laki-laki', 'Perempuan'];

  @override
  void dispose() {
    _namaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  // Menampilkan DatePicker untuk Tanggal Lahir
  Future<void> _showDatePicker() async {
    final DateTime initialDate = DateTime(2000);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ScreenColorHelper.getPrimaryAction(context),
              onPrimary: Colors.white,
              onSurface: ScreenColorHelper.getHeadingText(context),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _tanggalLahirController.text = pickedDate.toFormattedString;
      });
    }
  }

  // Logika Eksekusi Pendaftaran
  Future<void> _performRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_cbSyaratKetentuan) {
      context.showSnackBar('Anda harus menyetujui Syarat & Ketentuan');
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi Delay Proses Pendaftaran
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      // Simpan data pendaftaran ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserName, _namaController.text.trim());
      await prefs.setString(AppConstants.keyUserEmail, _emailController.text.trim());
      
      if (!mounted) return;

      setState(() => _isLoading = false);
      
      if (context.mounted) {
        context.showSnackBar('Pendaftaran Berhasil! Menuju ke Ekstraksi Foto.');
      }

      // Navigasi ke Layar Foto Informasi (Ekstraksi Foto)
      Navigator.pushReplacementNamed(context, '/foto-informasi');
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showSnackBar('Terjadi kesalahan saat mendaftar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);

    return Scaffold(
      backgroundColor: AppColors.softBlueBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: GradientHelper.modernLightGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header
                  ScreenHeader(title: AppStrings.titleDaftar),
                  
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.subtitleDaftar,
                    style: TextStyle(color: bodyColor.withValues(alpha: 0.6), fontSize: 13),
                  ),
                  const SizedBox(height: 32),

                  // 2. Input Nama Lengkap
                  _buildLabel(AppStrings.labelNamaLengkap),
                  CustomInputBox(
                    controller: _namaController,
                    hintText: AppStrings.hintNamaLengkap,
                    prefixIcon: Icon(Icons.person_outline_rounded, size: 20, color: bodyColor),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Nama lengkap wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),

                  // 3. Input Tempat & Tanggal Lahir Row
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(AppStrings.labelTempatLahir),
                            CustomInputBox(
                              controller: _tempatLahirController,
                              hintText: 'Kota',
                              prefixIcon: Icon(Icons.location_city_rounded, size: 18, color: bodyColor),
                              validator: (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(AppStrings.labelTanggalLahir),
                            CustomInputBox(
                              controller: _tanggalLahirController,
                              hintText: 'Pilih Tanggal',
                              prefixIcon: Icon(Icons.calendar_today_rounded, size: 18, color: bodyColor),
                              onTap: _showDatePicker,
                              readOnly: true,
                              validator: (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 5. Input Jenis Kelamin (Dropdown)
                  _buildLabel(AppStrings.labelJenisKelamin),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedJenisKelamin,
                    decoration: ScreenStyleHelper.modernInputDecoration(
                      context: context,
                      hintText: AppStrings.hintJenisKelamin,
                      prefixIcon: Icons.wc_rounded,
                    ).copyWith(
                      fillColor: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.8),
                      filled: true,
                    ),
                    dropdownColor: ScreenColorHelper.getSurfaceColor(context),
                    style: TextStyle(color: headingColor, fontSize: 14),
                    items: _genderList
                        .map((gender) => DropdownMenuItem(
                          value: gender, 
                          child: Text(
                            gender == 'Laki-laki' ? AppStrings.genderMale : AppStrings.genderFemale, 
                            style: const TextStyle(fontSize: 14)
                          )
                        ))
                        .toList(),
                    onChanged: _isLoading ? null : (value) => setState(() => _selectedJenisKelamin = value),
                    validator: (value) => value == null || value.isEmpty ? 'Jenis kelamin wajib dipilih' : null,
                  ),
                  const SizedBox(height: 20),

                  // 6. Input Alamat
                  _buildLabel(AppStrings.labelAlamat),
                  CustomInputBox(
                    controller: _alamatController,
                    hintText: AppStrings.hintAlamat,
                    prefixIcon: Icon(Icons.map_outlined, size: 20, color: bodyColor),
                    maxLines: 2,
                    validator: (value) => value == null || value.trim().isEmpty ? 'Alamat wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),

                  // 7. Input Email
                  _buildLabel(AppStrings.labelEmailAddr),
                  CustomInputBox(
                    controller: _emailController,
                    hintText: AppStrings.hintEmailDaftar,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.alternate_email_rounded, size: 20, color: bodyColor),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
                      if (!value.trim().isValidEmail) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 8. Password Fields
                  _buildLabel(AppStrings.labelPassword),
                  CustomInputBox(
                    controller: _passwordController,
                    hintText: AppStrings.hintPasswordDaftar,
                    obscureText: _obscurePassword,
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 20, color: bodyColor),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: bodyColor.withValues(alpha: 0.5)),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) => value == null || value.trim().length < 6 ? 'Sandi minimal 6 karakter' : null,
                  ),
                  const SizedBox(height: 20),

                  // 9. Input Konfirmasi Kata Sandi
                  _buildLabel(AppStrings.labelKonfirmasiPassword),
                  CustomInputBox(
                    controller: _konfirmasiPasswordController,
                    hintText: AppStrings.hintConfirmPassword,
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icon(Icons.lock_reset_rounded, size: 20, color: bodyColor),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: bodyColor.withValues(alpha: 0.5)),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Ulangi kata sandi Anda';
                      if (value.trim() != _passwordController.text.trim()) return 'Kata sandi tidak cocok';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 10. Checkbox Syarat & Ketentuan
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _cbSyaratKetentuan,
                    title: Text(AppStrings.termsAndConditions, style: TextStyle(fontSize: 12, color: bodyColor)),
                    onChanged: _isLoading ? null : (value) => setState(() => _cbSyaratKetentuan = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                  ),
                  
                  const SizedBox(height: 24),

                  // 11. Tombol Daftar
                  AppButton(
                    text: AppStrings.btnDaftar.toUpperCase(),
                    isLoading: _isLoading,
                    onPressed: _performRegister,
                    backgroundColor: primaryColor,
                  ),
                  
                  const SizedBox(height: 28),

                  // 12. Footer Navigasi Ke Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.promptSudahPunyaAkun, style: TextStyle(color: bodyColor, fontSize: 14)),
                      GestureDetector(
                        onTap: _isLoading ? null : () => Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          AppStrings.actionMasuk,
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: ScreenColorHelper.getHeadingText(context),
        ),
      ),
    );
  }
}
