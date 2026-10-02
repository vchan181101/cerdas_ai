import "dart:async";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../values/values.dart';
import '../../helpers/color/gradient_helper.dart';

class OtpVerificationScreen extends StatefulWidget{
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Controller dan FocusNode untuk 4-digit OTP
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  String _loadingStatus = 'Verifikasi kode...';

  // Timer Kirim Ulang Kode OTP (60 Detik)
  Timer? _timer;
  int _startSeconds = 60;
  bool _canResend = false;
  String _userEmail = '';
  bool _isFromRegister = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Membaca argumen email dan alur flow dari halaman sebelumnya
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      if (args.containsKey('email')) {
        _userEmail = args['email'] ?? '';
      }
      if (args['flow'] == 'register' || args['isFromRegister'] == true) {
        _isFromRegister = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Timer Hitung Mundur 60 Detik
  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _startSeconds = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  // Verifikasi Kode OTP
  Future<void> _performVerifyOtp() async {
    final otpCode = _controllers.map((c) => c.text.trim()).join();

    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap masukkan 4-digit kode OTP lengkap'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _loadingStatus = 'Verifikasi kode...';
    });

    // Simulasi Delay 1.5 Detik
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode OTP Berhasil Diverifikasi!')),
    );

    // Navigasi sesuai alur pendaftaran (Register) atau lupa kata sandi
    if (_isFromRegister) {
      Navigator.pushReplacementNamed(
        context,
        '/akun-telah-dibuat',
        arguments: {'email': _userEmail},
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/password-baru',
        arguments: {'email': _userEmail},
      );
    }
  }

  // Kirim Ulang Kode OTP
  Future<void> _performResendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _loadingStatus = 'Mengirim kode baru...';
    });

    // Simulasi Delay 2 Detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode OTP baru dikirimkan kembali ke $_userEmail'),
      ),
    );

    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBlueBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: GradientHelper.modernLightGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
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
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.navyPrimary),
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                      ),
                    ),
                    const Text(
                      'Verifikasi OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 2. Icon Email / Pesan
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navyPrimary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_rounded,
                      size: 70,
                      color: AppColors.orangeAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 3. Title & Subtitle Info Email
                const Text(
                  'Masukkan Kode OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _userEmail.isNotEmpty
                      ? 'Kode verifikasi 4-digit telah dikirimkan ke $_userEmail'
                      : 'Kode verifikasi 4-digit telah dikirimkan ke email Anda',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // 4. Box Input Kode OTP 4-Digit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFE8D6), // Oranye lembut
                            AppColors.white,   // Putih
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFFFCCA0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.orangeAccent.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (event) {
                          // Deteksi penekanan tombol Backspace saat kotak kosong
                          if (event is KeyDownEvent &&
                              event.logicalKey == LogicalKeyboardKey.backspace) {
                            if (_controllers[index].text.isEmpty && index > 0) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index - 1]);
                            }
                          }
                        },
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          enabled: !_isLoading,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: AppColors.black,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.navyPrimary,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index + 1]);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // 5. Progress Bar Loading & Teks Status
                if (_isLoading)
                  Column(
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.navyPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _loadingStatus,
                        style: const TextStyle(
                          color: AppColors.navyPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // 6. Tombol Verifikasi
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performVerifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navyPrimary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'VERIFIKASI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 7. Footer Kirim Ulang OTP & Countdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tidak menerima kode? ',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap:
                      (_isLoading || !_canResend) ? null : _performResendOtp,
                      child: Text(
                        _canResend ? 'Kirim Ulang' : 'Tunggu ($_startSeconds s)',
                        style: TextStyle(
                          color: _canResend ? AppColors.orangeAccent : AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}