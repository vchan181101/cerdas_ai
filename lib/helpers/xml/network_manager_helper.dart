import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  /// Mengecek apakah perangkat terhubung ke internet (Wi-Fi, Cellular, Ethernet)
  /// Konversi dari NetworkManager.isConnected(Context context) di Java
  static Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivityResults =
    await Connectivity().checkConnectivity();

    return connectivityResults.contains(ConnectivityResult.wifi) ||
        connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.ethernet);
  }

  /// Mendapatkan aliran data (Stream) status koneksi secara real-time
  static Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged;
  }
}