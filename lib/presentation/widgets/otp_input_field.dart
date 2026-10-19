import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../values/colors.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputField({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<FocusNode> _listenerFocusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _listenerFocusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in _listenerFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Menggabungkan seluruh digit OTP menjadi string tunggal
  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onTextChanged(int index, String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(_otpValue);
    }

    // Pindah ke kotak berikutnya jika 1 digit terisi
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Jika seluruh digit OTP telah terisi lengkap
    if (_otpValue.length == widget.length) {
      widget.onCompleted(_otpValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 50,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: KeyboardListener(
            focusNode: _listenerFocusNodes[index],
            onKeyEvent: (KeyEvent event) {
              // Logika hapus (Backspace) jika kosong, pindah ke kotak sebelumnya
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.indigoPrimary, width: 2),
                ),
              ),
              onChanged: (value) => _onTextChanged(index, value),
            ),
          ),
        );
      }),
    );
  }
}
