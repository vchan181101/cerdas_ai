import 'package:flutter/material.dart';

class BottomNavColorHelper {
  // Warna sesuai dengan definisi bottom_nav_color.xml
  static const Color colorChecked = Color(0xFF6366F1); // #6366F1 (Aktif)
  static const Color colorPressed = Color(0xFF4F46E5); // #4F46E5 (Ditekan)
  static const Color colorDefault = Color(0xFF94A3B8); // #94A3B8 (Normal)

  /// Mengubah warna item (Icon / Text) sesuai status interaksi (State)
  /// Pengganti ColorStateList di Android Native
  static WidgetStateColor get bottomNavColorState {
    return WidgetStateColor.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return colorChecked;
      }
      if (states.contains(WidgetState.pressed)) {
        return colorPressed;
      }
      return colorDefault;
    });
  }

  /// ThemeData kustom untuk BottomNavigationBar jika diterapkan secara global
  static BottomNavigationBarThemeData get themeData {
    return const BottomNavigationBarThemeData(
      selectedItemColor: colorChecked,
      unselectedItemColor: colorDefault,
      selectedIconTheme: IconThemeData(color: colorChecked),
      unselectedIconTheme: IconThemeData(color: colorDefault),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: colorChecked,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: colorDefault,
      ),
    );
  }
}