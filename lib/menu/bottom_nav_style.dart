import 'package:flutter/material.dart';
import '../values/colors.dart';
import '../values/dark_colors.dart';

class BottomNavStyle {
  /// Warna aktif untuk item menu (Modern Indigo Blue)
  static const Color activeColor = AppColors.indigoPrimary;

  /// Warna tidak aktif untuk item menu (Muted Blue Gray)
  static const Color inactiveColor = Color(0xFF94A3B8);

  /// Warna latar belakang Bottom Navigation Default
  static const Color backgroundColor = AppColors.white;

  /// Dekorasi container untuk Bottom Navigation (Default untuk backward-compatibility)
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

  /// Dekorasi container adaptif tema:
  /// - Tema Gelap: Container gelap (AppDarkColors.white) dengan border atas & shadow gelap
  /// - Tema Terang: Container biru-putih (gradien 0xFFEBF4FE ke Colors.white) dengan border biru muda
  static BoxDecoration getContainerDecoration(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return BoxDecoration(
        color: AppDarkColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF334155).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      );
    } else {
      return BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEBF4FE), // Biru muda lembut (biru-putih)
            Color(0xFFFFFFFF), // Putih
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFBFDBFE).withValues(alpha: 0.7),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      );
    }
  }

  /// Gaya teks untuk label aktif adaptif tema:
  /// - Tema Gelap: Teks Putih (Colors.white)
  /// - Tema Terang: Teks Hitam (Colors.black)
  static TextStyle getSelectedLabelStyle(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black,
      letterSpacing: 0.5,
    );
  }

  /// Gaya teks untuk label tidak aktif adaptif tema:
  /// - Tema Gelap: Teks Putih redup (Colors.white70)
  /// - Tema Terang: Teks Hitam redup (Colors.black87)
  static TextStyle getUnselectedLabelStyle(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : Colors.black87,
      letterSpacing: 0.5,
    );
  }

  /// Gaya teks untuk label aktif default
  static const TextStyle activeLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: activeColor,
    letterSpacing: 0.5,
  );

  /// Gaya teks untuk label tidak aktif default
  static const TextStyle inactiveLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: inactiveColor,
    letterSpacing: 0.5,
  );
}
