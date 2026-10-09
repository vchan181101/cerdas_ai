import 'package:flutter/material.dart';
import '../values/colors.dart';
import '../values/dark_colors.dart';
import 'color/screen_color_helper.dart';

/// Helper untuk standarisasi dekorasi input (TextFormField) di seluruh aplikasi.
/// Terintegrasi dengan sistem warna modern Cerdas AI.
class InputBoxHelper {
  /// Membangun dekorasi input yang konsisten dengan dukungan Dark Mode.
  static InputDecoration buildInputDecoration({
    required BuildContext context,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isError = false,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color columnColor = isDark ? AppDarkColors.white : Colors.white;
    final Color borderColor = isDark ? AppDarkColors.inputBorder : AppColors.inputBorder;
    final Color hintColor = isDark ? Colors.white54 : Colors.black45;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor, fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: columnColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),

      // Border Standar (Idle)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isError ? Colors.redAccent : borderColor,
          width: 1.2,
        ),
      ),

      // Border saat Fokus (Active)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isError ? Colors.redAccent : ScreenColorHelper.getPrimaryAction(context),
          width: 2.0,
        ),
      ),

      // Border saat terjadi kesalahan validasi
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),

      // Border saat fokus namun masih error
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2.0,
        ),
      ),
    );
  }
}
