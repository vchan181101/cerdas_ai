import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../widgets/widgets.dart';

class InputBoxDemoScreen extends StatefulWidget {
  const InputBoxDemoScreen({super.key});

  @override
  State<InputBoxDemoScreen> createState() => _InputBoxDemoScreenState();
}

class _InputBoxDemoScreenState extends State<InputBoxDemoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleFormSubmission() async {
    final isValid = _formKey.currentState!.validate();
    
    setState(() {
      _hasError = !isValid;
    });

    if (isValid) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      context.showSnackBar('Form Berhasil Terkirim!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: AppBar(
        title: const Text('Input Box & Button Demo'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Demo Input Modern',
                style: ScreenStyleHelper.getScreenTitleStyle(context),
              ).paddingOnly(bottom: 8),
              
              Text(
                'Halaman ini menunjukkan penggunaan CustomInputBox dan AppButton dengan penanganan state yang aman.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ).paddingOnly(bottom: 24),

              // 1. Email Input
              Text(
                AppStrings.labelEmail,
                style: ScreenStyleHelper.getLabelStyle(context),
              ).paddingOnly(bottom: 8),

              CustomInputBox(
                controller: _emailController,
                hintText: AppStrings.hintEmail,
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                keyboardType: TextInputType.emailAddress,
                isError: _hasError,
                suffixIcon: _emailController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.cancel_rounded, size: 18, color: AppColors.iconTint),
                      onPressed: () {
                        _emailController.clear();
                      },
                    )
                  : null,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!value.trim().isValidEmail) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // 2. Password Input
              Text(
                AppStrings.labelPassword,
                style: ScreenStyleHelper.getLabelStyle(context),
              ).paddingOnly(bottom: 8),

              CustomInputBox(
                controller: _passwordController,
                hintText: AppStrings.hintPassword,
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                obscureText: _obscurePassword,
                isError: _hasError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: AppColors.iconTint,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Kata sandi minimal 6 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              AppButton(
                text: 'SUBMIT DEMO',
                isLoading: _isLoading,
                icon: Icons.send_rounded,
                onPressed: _handleFormSubmission,
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.indigoPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'KEMBALI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.indigoPrimary,
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
}
