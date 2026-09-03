import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleHelper {
  static const String _keySelectedLanguage = 'APP_LANG_CODE';
  static const String defaultLanguageCode = 'in'; // Default: Indonesia ("in" atau "id")

  /// Mengambil kode bahasa yang tersimpan dari SharedPreferences
  static Future<String> getPersistedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedLanguage) ?? defaultLanguageCode;
  }

  /// Mengubah dan menyimpan kode bahasa baru ke SharedPreferences
  static Future<void> persistLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedLanguage, languageCode);
  }

  /// Mengonversi string kode bahasa (misal: "en-US", "in", "es-419") menjadi objek `Locale` Flutter
  static Locale parseLocale(String langCode) {
    if (langCode.contains('-')) {
      final parts = langCode.split('-');
      return Locale(parts[0], parts[1]);
    }
    // Flutter biasanya menggunakan 'id' untuk Bahasa Indonesia, namun tetap mendukung 'in'
    if (langCode == 'in') {
      return const Locale('id', 'ID');
    }
    return Locale(langCode);
  }

  /// Mengambil `Locale` aktif aplikasi yang sudah tersimpan
  static Future<Locale> getSavedLocale() async {
    final langCode = await getPersistedLanguage();
    return parseLocale(langCode);
  }

  /// Mengubah bahasa aplikasi secara permanen
  static Future<Locale> setLocale(String languageCode) async {
    await persistLanguage(languageCode);
    return parseLocale(languageCode);
  }
}