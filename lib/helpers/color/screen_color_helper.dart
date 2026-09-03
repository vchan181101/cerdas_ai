import 'package:flutter/material.dart';
import '../../values/colors.dart';
import '../../values/dark_colors.dart';

class ScreenColorHelper {
  /// Warna Latar Belakang Layar
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Alias untuk compatibility
  static Color screenBackground(BuildContext context) => getBackgroundColor(context);

  /// Warna Kontainer / Card Modern
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppDarkColors.white
        : AppColors.white;
  }

  /// Alias untuk compatibility
  static Color surfaceCard(BuildContext context) => getSurfaceColor(context);

  /// Warna Aksen untuk Tombol Aksi Utama
  static Color getPrimaryAction(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Alias untuk compatibility
  static Color primaryAction(BuildContext context) => getPrimaryAction(context);

  /// Warna untuk teks judul yang menonjol
  static Color getHeadingText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.textPrimary;
  }

  /// Alias untuk compatibility
  static Color headingText(BuildContext context) => getHeadingText(context);

  /// Warna untuk teks deskripsi yang lebih redup
  static Color getBodyText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : AppColors.textMuted;
  }

  /// Alias untuk compatibility
  static Color bodyText(BuildContext context) => getBodyText(context);

  /// Warna latar belakang filter chip saat aktif
  static Color getFilterActiveBackground(BuildContext context) {
    return Theme.of(context).colorScheme.primary.withValues(alpha: 0.15);
  }

  /// Alias untuk compatibility
  static Color filterActiveBackground(BuildContext context) => getFilterActiveBackground(context);

  /// Mendapatkan skema warna berdasarkan status (Success, Warning, Error)
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return AppColors.emeraldSuccess;
      case 'warning':
        return Colors.orangeAccent;
      case 'error':
        return Colors.redAccent;
      default:
        return AppColors.iconTint;
    }
  }

  /// Warna transparan untuk overlay
  static Color getGlassOverlay(BuildContext context) {
    return (Theme.of(context).brightness == Brightness.dark ? Colors.black : AppColors.white)
        .withValues(alpha: 0.1);
  }
}
