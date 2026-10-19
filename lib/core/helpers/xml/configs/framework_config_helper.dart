/// Helper Konfigurasi Framework & Fullstack (Konversi dari framework_settings.xml)
/// Mengatur lingkungan eksekusi, timeout API, dan integrasi modul.
class FrameworkConfigHelper {
  // --- API Environment ---
  static const String currentEnv = 'development'; // 'staging' | 'production'
  static const int apiTimeoutMs = 30000;
  static const int maxRetryCount = 3;

  // --- Feature Flags ---
  static const bool enableAIVoice = true;
  static const bool enableOfflineMode = false;
  static const bool debugLogging = true;

  // --- External Integrations ---
  static const String googleAuthClientId = 'CLIENT_ID_XML_REPLACEMENT';
  static const String appleTeamId = 'TEAM_ID_XML_REPLACEMENT';

  /// Mendapatkan Base URL berdasarkan konfigurasi XML Framework
  static String getBaseUrl() {
    switch (currentEnv) {
      case 'production':
        return 'https://api.aicerdas.com/v1';
      case 'staging':
        return 'https://staging.api.aicerdas.com/v1';
      default:
        return 'http://10.0.2.2:8080/api'; // Emulator Localhost
    }
  }
}
