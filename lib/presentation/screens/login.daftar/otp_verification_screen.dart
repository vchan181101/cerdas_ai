import "dart:async";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../values/values.dart';

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bodyColor = isDark ? Colors.white70 : Colors.black87;
    final iconColor = isDark ? Colors.white : Colors.black;
    final columnColor = isDark ? AppDarkColors.white : Colors.white;
    final bgColor = isDark ? AppDarkColors.bgLight : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        color: bgColor,
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
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: iconColor),
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      'Verifikasi OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 2. Icon Email / Pesan (Lingkaran Kolom Gelap di Dark, Putih di Light)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: columnColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppDarkColors.inputBorder : AppColors.inputBorder,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mark_email_unread_rounded,
                      size: 70,
                      color: iconColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 3. Title & Subtitle Info Email
                Text(
                  'Masukkan Kode OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _userEmail.isNotEmpty
                      ? 'Kode verifikasi 4-digit telah dikirimkan ke $_userEmail'
                      : 'Kode verifikasi 4-digit telah dikirimkan ke email Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // 4. Box Input Kode OTP 4-Digit (Kolom Gelap di Dark Mode, Putih di Light Mode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark ? AppDarkColors.white : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppDarkColors.inputBorder : AppColors.inputBorder,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
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
                          cursorColor: textColor,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
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
                                color: AppColors.indigoPrimary,
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
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: iconColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _loadingStatus,
                        style: TextStyle(
                          color: textColor,
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
                      backgroundColor: AppColors.indigoPrimary,
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
                    Text(
                      'Tidak menerima kode? ',
                      style: TextStyle(color: bodyColor, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap:
                      (_isLoading || !_canResend) ? null : _performResendOtp,
                      child: Text(
                        _canResend ? 'Kirim Ulang' : 'Tunggu ($_startSeconds s)',
                        style: TextStyle(
                          color: textColor,
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