import 'package:flutter/material.dart';

class BottomTextColorHelper {
  // Warna sesuai dengan definisi bottom_text_color.xml
  static const Color colorChecked = Color(0xFF6366F1);  // #6366F1 (Selected/Checked)
  static const Color colorPressed = Color(0xFF4F46E5);  // #4F46E5 (Pressed)
  static const Color colorDisabled = Color(0xFFCBD5E1); // #CBD5E1 (Disabled)
  static const Color colorDefault = Color(0xFF94A3B8);  // #94A3B8 (Default/Normal)

  /// Resolusi warna dinamis berdasarkan status interaksi (WidgetState)
  /// Pengganti ColorStateList dari res/color/bottom_text_color.xml
  static WidgetStateColor get textColorState {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return colorDisabled;
      }
      if (states.contains(WidgetState.selected)) {
        return colorChecked;
      }
      if (states.contains(WidgetState.pressed)) {
        return colorPressed;
      }
      return colorDefault;
    });
  }

  /// TextStyle helper untuk teks label aktif
  static TextStyle get selectedTextStyle {
    return const TextStyle(
      color: colorChecked,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
  }

  /// TextStyle helper untuk teks label non-aktif
  static TextStyle get unselectedTextStyle {
    return const TextStyle(
      color: colorDefault,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
  }
}