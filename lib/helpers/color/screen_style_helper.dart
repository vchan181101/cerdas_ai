import 'package:flutter/material.dart';
import '../../values/colors.dart';
import 'screen_color_helper.dart';

class ScreenStyleHelper {
  /// Dekorasi Card Modern untuk konten di layar
  static BoxDecoration getModernCardDecoration(BuildContext context) => BoxDecoration(
    color: ScreenColorHelper.getSurfaceColor(context),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// Dekorasi Kotak Pencarian (Search Bar)
  static BoxDecoration getSearchBarDecoration(BuildContext context) => BoxDecoration(
    color: ScreenColorHelper.getSurfaceColor(context),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.inputBorder),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.02),
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );

  /// Dekorasi Tombol Filter
  static BoxDecoration getFilterButtonDecoration(BuildContext context, {bool isSelected = false}) {
    return BoxDecoration(
      color: isSelected 
          ? ScreenColorHelper.getFilterActiveBackground(context) 
          : ScreenColorHelper.getSurfaceColor(context),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isSelected ? ScreenColorHelper.getPrimaryAction(context) : AppColors.inputBorder,
      ),
    );
  }

  /// Dekorasi Input Box Modern
  static InputDecoration modernInputDecoration({
    required BuildContext context,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.iconTint, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: AppColors.iconTint, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: ScreenColorHelper.getSurfaceColor(context),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ScreenColorHelper.getPrimaryAction(context), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  /// Gaya Teks untuk Judul Layar
  static TextStyle getScreenTitleStyle(BuildContext context) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: ScreenColorHelper.getHeadingText(context),
  );

  /// Gaya Teks untuk Sub-Judul atau Label
  static TextStyle getLabelStyle(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
  );
  
  // Legacy aliases for backward compatibility (where context is not easily available, though not recommended)
  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  
  static const TextStyle screenTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}
