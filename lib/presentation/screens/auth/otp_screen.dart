import 'dart:async';
import 'package:flutter/material.dart';

import '../../values/colors.dart';
import '../../widgets/otp_input_field.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _enteredOtp = '';
  int _startSeconds = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Timer Hitung Mundur Kirim Ulang Kode OTP
  void _startResendTimer() {
    setState(() {
      _startSeconds = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() {
          _timer?.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  // Verifikasi Kode OTP
  void _verifyOtp() {
    if (_enteredOtp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 4 digit kode OTP dengan lengkap')),
      );
      return;
    }

    // Simulasi Verifikasi OTP Berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verifikasi OTP Berhasil!')),
    );

    // Pindah ke Dashboard / Halaman Utama
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 20),

              // Title & Description
              const Text(
                'Verifikasi Kode OTP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kami telah mengirimkan 4 digit kode verifikasi ke email/nomor Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 40),

              // 4 Digit Input OTP Widget (Konversi XML activity_otp)
              OtpInputField(
                length: 4,
                onChanged: (value) {
                  _enteredOtp = value;
                },
                onCompleted: (otp) {
                  _enteredOtp = otp;
                  _verifyOtp();
                },
              ),

              const SizedBox(height: 40),

              // Tombol Verifikasi OTP
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigoPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Verifikasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Kirim Ulang Kode OTP Timer Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tidak menerima kode? ',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  _canResend
                      ? InkWell(
                    onTap: _startResendTimer,
                    child: const Text(
                      'Kirim Ulang',
                      style: TextStyle(
                        color: AppColors.indigoPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  )
                      : Text(
                    'Kirim ulang dalam ${_startSeconds}s',
                    style: const TextStyle(
                      color: AppColors.indigoPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}