import 'package:flutter/material.dart';
import '../values/colors.dart';

class BottomNavStyle {
  /// Warna aktif untuk item menu (Modern Indigo)
  static const Color activeColor = AppColors.indigoPrimary;

  /// Warna tidak aktif untuk item menu (Muted Blue Gray)
  static const Color inactiveColor = Color(0xFF94A3B8);

  /// Warna latar belakang Bottom Navigation (Modern Glassy White)
  static const Color backgroundColor = AppColors.white;

  /// Dekorasi container untuk Bottom Navigation (Modern Rounded with Shadow)
  static BoxDecoration containerDecoration = BoxDecoration(
    color: backgroundColor,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, -4),
      ),
    ],
  );

  /// Gaya teks untuk label aktif
  static const TextStyle activeLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: activeColor,
    letterSpacing: 0.5,
  );

  /// Gaya teks untuk label tidak aktif
  static const TextStyle inactiveLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: inactiveColor,
    letterSpacing: 0.5,
  );
}
