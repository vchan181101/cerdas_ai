import 'package:flutter/material.dart';
import '../helpers/xml/network_security_helper.dart';

class NetworkDemoScreen extends StatefulWidget {
  const NetworkDemoScreen({super.key});

  @override
  State<NetworkDemoScreen> createState() => _NetworkDemoScreenState();
}

class _NetworkDemoScreenState extends State<NetworkDemoScreen> {
  bool _isConnected = false;
  bool _isChecking = true;
  bool _isDevelopment = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() => _isChecking = true);
    final hasNetwork = await NetworkSecurityHelper.isNetworkAvailable();
    setState(() {
      _isConnected = hasNetwork;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiUrl = NetworkSecurityHelper.getBaseApiUrl(isDevelopment: _isDevelopment);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Security Demo'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Status Koneksi Internet
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      _isChecking
                          ? Icons.sync
                          : (_isConnected ? Icons.wifi : Icons.wifi_off),
                      color: _isConnected ? Colors.green : Colors.red,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Jaringan:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _isChecking
                              ? 'Memeriksa...'
                              : (_isConnected ? 'Terhubung ke Internet' : 'Tidak Ada Koneksi'),
                          style: TextStyle(
                            color: _isConnected ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Segment Base API URL
            const Text(
              'Base API URL:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SelectableText(
                apiUrl,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Toggle Development / Production
            SwitchListTile(
              title: const Text('Mode Development (HTTP 10.0.2.2)'),
              subtitle: const Text('Ganti ke HTTPS Production jika dimatikan'),
              value: _isDevelopment,
              onChanged: (val) {
                setState(() => _isDevelopment = val);
              },
            ),

            const Spacer(),
            ElevatedButton.icon(
              onPressed: _checkConnection,
              icon: const Icon(Icons.refresh),
              label: const Text('Cek Ulang Koneksi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}