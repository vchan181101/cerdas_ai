import "dart:async";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cerdas_ai/core/values/values.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

class OtpVerificationScreen extends StatefulWidget {
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

    final targetEmail = _userEmail.isNotEmpty ? _userEmail : 'email Anda';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode OTP baru dikirimkan kembali ke $targetEmail'),
      ),
    );

    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final iconColor = isDark ? Colors.white : Colors.black;
    final columnColor = isDark ? AppDarkColors.white : Colors.white;
    final bgColor = isDark ? AppDarkColors.bgLight : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: BackgroundWrapper(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top Bar / Tombol Kembali & Judul Verifikasi OTP
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: iconColor),
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      'Verifikasi OTP',
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

                // 2. Icon Email / Badge Bulat dengan Halo Glow Ring sesuai referensi Gambar 3
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
                          color: columnColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppDarkColors.inputBorder : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.35 : 0.12),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.mark_email_unread_rounded,
                            size: 52,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 3. Title & Subtitle Info Email
                Text(
                  'Masukkan Kode OTP',
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
                  'Kode verifikasi 4-digit telah dikirimkan ke',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _userEmail.isNotEmpty ? _userEmail : 'sandra@gmail.com',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 36),

                // 4. Box Input Kode OTP 4-Digit: Dikosongin awalnya & muncul saat diketik
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    final hasValue = _controllers[index].text.isNotEmpty;
                    final isFocused = _focusNodes[index].hasFocus;

                    return Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark ? AppDarkColors.white : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isFocused
                              ? const Color(0xFF3B82F6)
                              : (hasValue
                                  ? const Color(0xFF6366F1)
                                  : (isDark ? AppDarkColors.inputBorder : const Color(0xFFCBD5E1))),
                          width: isFocused ? 2.0 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isFocused || hasValue)
                                ? const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.35 : 0.16)
                                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                            blurRadius: (isFocused || hasValue) ? 10 : 6,
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
                            hintText: '•',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {}); // refresh border & visual
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

                // 5. Progress Bar Loading & Teks Status jika sedang loading
                if (_isLoading)
                  Column(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: isDark ? Colors.white : const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(height: 10),
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

                // 6. Tombol Verifikasi (Gradien Biru ke Ungu sesuai referensi Gambar 3)
                AppButton(
                  text: 'VERIFIKASI',
                  isLoading: _isLoading,
                  onPressed: _performVerifyOtp,
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
                const SizedBox(height: 28),

                // 7. Footer Kirim Ulang OTP & Countdown (Orange / Terracotta)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tidak menerima kode? ',
                      style: TextStyle(color: bodyColor, fontSize: 13.5),
                    ),
                    GestureDetector(
                      onTap: (_isLoading || !_canResend) ? null : _performResendOtp,
                      child: Text(
                        _canResend ? 'Kirim Ulang' : 'Tunggu ($_startSeconds s)',
                        style: const TextStyle(
                          color: Color(0xFFEA580C),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
