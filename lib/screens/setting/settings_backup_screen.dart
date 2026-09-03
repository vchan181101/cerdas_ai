import 'package:flutter/material.dart';
import '../../helpers/xml/backup_helper.dart';
import '../../values/colors.dart';

class SettingsBackupScreen extends StatefulWidget {
  const SettingsBackupScreen({super.key});

  @override
  State<SettingsBackupScreen> createState() => _SettingsBackupScreenState();
}

class _SettingsBackupScreenState extends State<SettingsBackupScreen> {
  String _tokenStatus = 'Belum Ada Token';

  @override
  void initState() {
    super.initState();
    _checkTokenStatus();
  }

  Future<void> _checkTokenStatus() async {
    final token = await BackupHelper.getSecureToken();
    if (!mounted) return;
    setState(() {
      _tokenStatus =
          (token != null) ? 'Token Tersimpan Aman (Encrypted)' : 'Kosong';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Security Demo'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Status Vault Token (Excluded Backup):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_tokenStatus, style: const TextStyle(color: AppColors.indigoPrimary)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await BackupHelper.saveSecureToken('JWT_SECURE_TOKEN_SAMPLE_12345');
                await BackupHelper.saveUserPreference('app_theme', 'dark');
                await _checkTokenStatus();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token & Preferensi Disimpan!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigoPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Simpan Session & Preferensi'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await BackupHelper.clearTempFiles();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File Sementara Berhasil Dihapus')),
                );
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Bersihkan Cache & Temp Files'),
            ),
          ],
        ),
      ),
    );
  }
}
