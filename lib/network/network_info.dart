import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get hasInternet;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection checker;

  NetworkInfoImpl(this.connectivity, this.checker);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results = await connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }

  /// Mengecek apakah benar-benar ada akses internet (bukan hanya terhubung ke WiFi tanpa internet)
  @override
  Future<bool> get hasInternet async => await checker.hasInternetAccess;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}
