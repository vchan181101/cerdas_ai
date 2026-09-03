import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'dark_colors.dart';

class AppThemes {
  /// Light Theme (Konversi dari Theme.CerdasAI / Theme.MaterialComponents.DayNight.NoActionBar)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Brand Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.purple500,
        primaryContainer: AppColors.purple700,
        onPrimary: AppColors.white,
        secondary: AppColors.teal200,
        secondaryContainer: AppColors.teal700,
        onSecondary: AppColors.black,
        surface: AppColors.bgLight,
        onSurface: AppColors.textPrimary,
      ),

      scaffoldBackgroundColor: AppColors.bgLight,

      // Status Bar & Navigation Bar Configuration
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.purple700, // android:statusBarColor
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Custom Input & Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple500,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  } // <-- Poin Perbaikan: Penutup getter lightTheme diletakkan di sini

  /// Dark Theme (Konversi dari res/values-night)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppDarkColors.bgLight,
      cardColor: AppDarkColors.white,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.indigoPrimary,
        surface: AppDarkColors.white,
        onSurface: AppDarkColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppDarkColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.indigoPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppDarkColors.inputBorder),
        ),
      ),
    );
  }
}