import 'package:flutter/material.dart';
import '../helpers/xml/backup_helper.dart';
import '../values/colors.dart';

class BackupRulesDemoScreen extends StatefulWidget {
  const BackupRulesDemoScreen({super.key});

  @override
  State<BackupRulesDemoScreen> createState() => _BackupRulesDemoScreenState();
}

class _BackupRulesDemoScreenState extends State<BackupRulesDemoScreen> {
  String _tokenStatus = 'Belum Tersimpan';
  String _themePreference = 'Belum Ada Preferensi';

  @override
  void initState() {
    super.initState();
    _loadDataStatus();
  }

  Future<void> _loadDataStatus() async {
    final token = await BackupHelper.getSecureCredential('user_auth_token');
    final theme = await BackupHelper.getUserPreference('app_theme');

    if (!mounted) return;

    setState(() {
      _tokenStatus = (token != null) ? 'Token Tersimpan (Aman dari Backup)' : 'Kosong';
      _themePreference = theme ?? 'Light (Termasuk dalam Backup)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Backup Rules Config Demo'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '1. Data Sensitif (Dikecualikan dari Cloud Backup):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _tokenStatus,
              style: const TextStyle(
                color: AppColors.indigoPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '2. Preferensi Aplikasi (Disertakan dalam Cloud Backup):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _themePreference,
              style: const TextStyle(
                color: AppColors.emeraldSuccess,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await BackupHelper.saveSecureCredential(
                  'user_auth_token',
                  'SECURE_JWT_TOKEN_123456',
                );
                await BackupHelper.saveUserPreference('app_theme', 'Dark Mode');
                await _loadDataStatus();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Data berhasil disimpan sesuai aturan backup_rules!',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigoPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Simpan Session & Preferensi'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await BackupHelper.clearCacheAndTempFiles();
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Folder Cache & File Sementara Berhasil Dihapus'),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
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
