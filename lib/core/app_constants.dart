import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Application Info
  static const String appName = 'Cerdas AI';
  static const String appVersion = '1.0.0';
  
  // 🔑 GOOGLE GEMINI API CONFIGURATION
  // Sistem akan mencoba mengambil dari --dart-define (GEMINI_API_KEY / API_KEY), lalu dari .env
  static String get geminiApiKey {
    const fromGeminiEnv = String.fromEnvironment('GEMINI_API_KEY');
    if (fromGeminiEnv.isNotEmpty) return fromGeminiEnv;

    const fromApiEnv = String.fromEnvironment('API_KEY');
    if (fromApiEnv.isNotEmpty) return fromApiEnv;
    
    try {
      return dotenv.env['GEMINI_API_KEY'] ??
          dotenv.env['API_KEY'] ??
          'MASUKKAN_API_KEY_GEMINI_ANDA_DI_SINI';
    } catch (_) {
      return 'MASUKKAN_API_KEY_GEMINI_ANDA_DI_SINI';
    }
  }
  
  // Model Mapping based on Tier
  static const String modelFree = 'gemini-1.5-flash';
  static const String modelPlus = 'gemini-1.5-flash-8b';
  static const String modelPro = 'gemini-1.5-pro';
  static const String modelUltra = 'gemini-1.5-pro'; // High Quota / Pay-as-you-go



  // Storage Keys
  static const String keyIsLoggedIn = 'IS_LOGGED_IN';
  static const String keyAuthToken = 'AUTH_TOKEN';
  static const String keyUserEmail = 'USER_EMAIL';
  static const String keyUserName = 'USER_NAME';
  static const String keyThemeMode = 'THEME_MODE';
  static const String keyChatHistory = 'CHAT_HISTORY';
  
  // Timeout values
  static const int apiTimeout = 30000; // 30 seconds
  
  // Assets Paths
  static const String logoPath = 'asset/ic_logo_aicerdas.jpg';
  static const String placeholderProfile = 'asset/ic_user.png';
}
