import 'package:flutter/material.dart';
import '../helpers/xml/data_extraction_helper.dart';

class DataExtractionDemoScreen extends StatefulWidget {
  const DataExtractionDemoScreen({super.key});

  @override
  State<DataExtractionDemoScreen> createState() => _DataExtractionDemoScreenState();
}

class _DataExtractionDemoScreenState extends State<DataExtractionDemoScreen> {
  String _sessionStatus = 'Tidak Ada Sesi Terenkripsi';
  String _currentTheme = 'Default (Light)';

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final token = await DataExtractionHelper.getSecureSession('user_token');
    final theme = await DataExtractionHelper.getAppPreference('app_theme');

    setState(() {
      _sessionStatus = token != null ? 'Token Tersimpan (Aman dari Backup)' : 'Belum Login';
      _currentTheme = theme ?? 'Light (Boleh Ter-backup)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Extraction Rules Demo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Status Kredensial (Cloud Excluded):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(_sessionStatus, style: const TextStyle(color: Colors.indigo)),

            const SizedBox(height: 16),
            const Text(
              'Status Preferensi Tema (Cloud Included):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(_currentTheme, style: const TextStyle(color: Colors.green)),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await DataExtractionHelper.setSecureSession('user_token', 'AUTH_KEY_EXCLUDED_12345');
                await DataExtractionHelper.setAppPreference('app_theme', 'Dark Theme');
                await _loadStoredData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data Berhasil Disimpan sesuai Aturan Rules!')),
                  );
                }
              },
              child: const Text('Simpan Data Sesi & Setting'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await DataExtractionHelper.purgeTempFiles();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Folder Cache & Temp Files Dibersihkan')),
                  );
                }
              },
              child: const Text('Hapus Berkas Sementara (Temp)'),
            ),
          ],
        ),
      ),
    );
  }
}