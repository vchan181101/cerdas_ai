import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../helpers/xml/network_manager_helper.dart';

class NetworkCheckExampleScreen extends StatelessWidget {
  const NetworkCheckExampleScreen({super.key});

  Future<void> _checkInternet(BuildContext context) async {
    bool connected = await NetworkManager.isConnected();

    if (!context.mounted) return;

    if (connected) {
      context.showSnackBar('Terhubung ke internet!');
    } else {
      context.showSnackBar('Tidak ada koneksi internet!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Check Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _checkInternet(context),
          child: const Text('Cek Koneksi'),
        ),
      ),
    );
  }
}
