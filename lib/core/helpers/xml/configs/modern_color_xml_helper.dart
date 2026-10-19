import 'package:flutter/material.dart';

/// Helper yang merepresentasikan konfigurasi warna modern (Konversi dari colors.xml modern)
/// Digunakan untuk standarisasi palet warna generasi mendatang pada Cerdas AI.
class ModernColorXmlHelper {
  // --- Palet Utama (Cyber Indigo & Emerald Neon) ---
  static const Color primaryCyber = Color(0xFF6366F1); // Indigo Vibe
  static const Color secondaryNeon = Color(0xFF10B981); // Emerald Energy
  
  // --- Latar Belakang (Glassmorphism & Depth) ---
  static const Color bgModernDark = Color(0xFF0F172A);
  static const Color bgModernLight = Color(0xFFF8FAFC);
  
  // --- Status & Feedback ---
  static const Color successModern = Color(0xFF22C55E);
  static const Color warningModern = Color(0xFFF59E0B);
  static const Color errorModern = Color(0xFFEF4444);
  static const Color infoModern = Color(0xFF3B82F6);

  /// Mendapatkan gradien modern untuk background Fullstack components
  static LinearGradient get techGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryCyber, Color(0xFF8B5CF6)],
      );

  /// Warna Surface untuk Database Cards (Clean & Minimalist)
  static Color get surfaceDatabase => const Color(0xFFFFFFFF).withValues(alpha: 0.9);
}
