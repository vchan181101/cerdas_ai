/// Helper Konfigurasi Keamanan (Konversi dari network_security_config.xml & security_rules.xml)
/// Menangani kebijakan enkripsi, hashing, dan protokol komunikasi.
class AdvancedSecurityHelper {
  // --- Encryption Policies ---
  static const String encryptionAlgorithm = 'AES-256-GCM';
  static const int keyRotationDays = 30;
  
  // --- Network Security ---
  static const bool allowCleartextTraffic = false; // Setara cleartextTrafficPermitted="false"
  static const List<String> certificatePins = [
    'sha256/ABC123...', // Contoh Pinning SHA256
    'sha256/XYZ789...'
  ];

  // --- Auth Policy ---
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);

  /// Mengecek apakah koneksi aman sesuai kebijakan framework
  static bool isProtocolSecure(String url) {
    return url.startsWith('https://');
  }
}
