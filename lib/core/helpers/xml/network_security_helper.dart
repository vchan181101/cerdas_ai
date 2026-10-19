import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkSecurityHelper {
  /// Memeriksa apakah perangkat terhubung ke koneksi internet aktif (Wi-Fi, Cellular, Ethernet)
  /// Konversi dari isNetworkAvailable() di Java
  static Future<bool> isNetworkAvailable() async {
    final List<ConnectivityResult> connectivityResults =
    await Connectivity().checkConnectivity();

    return connectivityResults.contains(ConnectivityResult.wifi) ||
        connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.ethernet);
  }

  /// Mendapatkan URL API Dasar (HTTP untuk Emulator Lokal, HTTPS untuk Production)
  /// Konversi dari getBaseApiUrl() di Java
  static String getBaseApiUrl({bool isDevelopment = false}) {
    if (isDevelopment) {
      // IP Loopback Emulator Android Studio (10.0.2.2) yang diizinkan di XML
      return "http://10.0.2.2:8080/api/";
    } else {
      return "https://api.aicerdas.com/v1/";
    }
  }
}