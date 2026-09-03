class AppConstants {
  // Application Info
  static const String appName = 'Cerdas AI';
  static const String appVersion = '1.0.0';
  
  // 🔑 GOOGLE GEMINI API CONFIGURATION
  // Masukkan API Key dari Google AI Studio di sini
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'MASUKKAN_API_KEY_GEMINI_ANDA_DI_SINI',
  );
  static const String geminiModel = 'gemini-1.5-flash'; // atau 'gemini-2.0-flash'
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');


  // Storage Keys
  static const String keyIsLoggedIn = 'IS_LOGGED_IN';
  static const String keyAuthToken = 'AUTH_TOKEN';
  static const String keyUserEmail = 'USER_EMAIL';
  static const String keyUserName = 'USER_NAME';
  static const String keyThemeMode = 'THEME_MODE';
  
  // Timeout values
  static const int apiTimeout = 30000; // 30 seconds
  
  // Assets Paths
  static const String logoPath = 'asset/ic_logo_aicerdas.jpg';
  static const String placeholderProfile = 'asset/ic_user.png';
}
