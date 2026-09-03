import 'package:flutter/material.dart';
import '../../values/colors.dart';

class GradientHelper {
  /// Gradient Modern Indigo untuk Background Splash atau Header
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo Primary
      Color(0xFF4F46E5), // Darker Indigo
    ],
  );

  /// Gradient Sukses (Emerald)
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );

  /// Gradient Soft untuk Card Background
  static LinearGradient softSurfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.white,
      AppColors.softBlueBg,
    ],
  );

  /// Gradient Modern Biru Muda (Aesthetic)
  static const LinearGradient modernLightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.softBlueBg,
      AppColors.white,
    ],
  );

  /// Gradient Dark Mode (Premium Dark Navy)
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1A365D), // Navy Primary
    ],
  );
}
