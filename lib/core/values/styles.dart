import 'package:flutter/material.dart';

class AppStyles {
  // ===========================================================================
  // CIRCULAR IMAGE / AVATAR STYLES (Konversi dari CircularImageView)
  // ===========================================================================

  /// Shape Decoration Melingkar (Equivalent cornerSize 50%)
  static const BoxDecoration circularDecoration = BoxDecoration(
    shape: BoxShape.circle,
  );

  /// Helper BoxDecoration untuk Foto Profil Melingkar dengan Border dan Shadow
  static BoxDecoration circularProfileDecoration({
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
    Color shadowColor = Colors.black12,
  }) {
    return BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// ClipRRect Border Radius Melingkar untuk Image Widget
  static BorderRadius get circularBorderRadius => BorderRadius.circular(999);

  // ===========================================================================
  // REUSABLE TEXT STYLES (Tambahan Style Teks Standar Aplikasi)
  // ===========================================================================

  static const TextStyle headingPrimary = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A),
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 14,
    color: Color(0xFF64748B),
  );
}