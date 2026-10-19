import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier global untuk memantau perubahan Tema Aplikasi secara Real-time
final ValueNotifier<ThemeMode> appThemeNotifier = ValueNotifier(ThemeMode.system);

class ThemeHelper {
  static const String _keyThemeMode = 'THEME_MODE';

  /// Mengambil Tema yang tersimpan dari SharedPreferences
  static Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_keyThemeMode) ?? 'system';
    
    switch (themeStr) {
      case 'light':
        appThemeNotifier.value = ThemeMode.light;
        break;
      case 'dark':
        appThemeNotifier.value = ThemeMode.dark;
        break;
      default:
        appThemeNotifier.value = ThemeMode.system;
    }
  }

  /// Menyimpan dan memperbarui Tema Aplikasi
  static Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeStr = 'system';
    
    if (mode == ThemeMode.light) themeStr = 'light';
    if (mode == ThemeMode.dark) themeStr = 'dark';
    
    await prefs.setString(_keyThemeMode, themeStr);
    appThemeNotifier.value = mode;
  }
  
  /// Helper untuk mendapatkan teks label dari ThemeMode
  static String getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      default:
        return 'Default System';
    }
  }
}
