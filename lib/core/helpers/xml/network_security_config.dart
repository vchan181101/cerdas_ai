import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkSecurityConfig {
  /// Memeriksa apakah perangkat terhubung ke koneksi internet aktif (Wi-Fi, Mobile Data, atau Ethernet)
  /// Menggantikan `isNetworkAvailable(Context context)` di Android Java.
  static Future<bool> isNetworkAvailable() async {
    final List<ConnectivityResult> connectivityResults =
    await Connectivity().checkConnectivity();

    return connectivityResults.any((result) =>
    result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }

  /// Mendapatkan URL API Dasar (Gunakan HTTP untuk Lokal, HTTPS untuk Production)
  /// Menggantikan `getBaseApiUrl(boolean isDevelopment)` di Android Java.
  static String getBaseApiUrl({bool isDevelopment = false}) {
    if (isDevelopment) {
      // IP 10.0.2.2 mengarah ke localhost komputer pengembangan dari Android Emulator
      return "http://10.0.2.2:8080/api/";
    } else {
      return "https://api.aicerdas.com/v1/";
    }
  }
}