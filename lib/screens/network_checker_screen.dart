import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../helpers/xml/network_manager_helper.dart';

class NetworkCheckerScreen extends StatefulWidget {
  const NetworkCheckerScreen({super.key});

  @override
  State<NetworkCheckerScreen> createState() => _NetworkCheckerScreenState();
}

class _NetworkCheckerScreenState extends State<NetworkCheckerScreen> {
  bool _isConnected = false;
  bool _isLoading = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();

    // Memantau perubahan koneksi secara real-time
    _connectivitySubscription = NetworkManager.onConnectivityChanged.listen((results) {
      final isOnline = results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet);

      setState(() {
        _isConnected = isOnline;
      });
    });
  }

  Future<void> _checkInitialConnection() async {
    final connected = await NetworkManager.isConnected();
    setState(() {
      _isConnected = connected;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Manager Demo'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  size: 80,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _isConnected ? 'Terhubung ke Internet' : 'Koneksi Terputus',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isConnected
                      ? 'Perangkat Anda siap digunakan untuk berkomunikasi dengan server.'
                      : 'Silakan periksa sambungan Wi-Fi atau paket data Anda.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _checkInitialConnection,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Cek Ulang Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}