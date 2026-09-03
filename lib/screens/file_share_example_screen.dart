import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/xml/file_path_helper.dart';

class FileShareExampleScreen extends StatefulWidget {
  const FileShareExampleScreen({super.key});

  @override
  State<FileShareExampleScreen> createState() => _FileShareExampleScreenState();
}

class _FileShareExampleScreenState extends State<FileShareExampleScreen> {
  String _statusText = 'Belum ada file dibuat.';

  Future<void> _createAndShareFile() async {
    try {
      // 1. Buat file sampel di direktori cache internal
      final cacheDir = await FilePathHelper.getCacheDirectory();
      final sampleFile = File('${cacheDir.path}/laporan_cerdas_ai.txt');
      await sampleFile.writeAsString('Dokumen Laporan Hasil Analisis Cerdas AI');

      setState(() {
        _statusText = 'File dibuat di: ${sampleFile.path}';
      });

      // 2. Bagikan file menggunakan FilePathHelper (Intent Share File)
      await FilePathHelper.shareFile(
        file: sampleFile,
        text: 'Bagikan Dokumen Laporan',
        mimeType: 'text/plain',
      );
    } catch (e) {
      setState(() {
        _statusText = 'Gagal membagikan file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Path & Share Demo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createAndShareFile,
              icon: const Icon(Icons.share),
              label: const Text('Buat & Bagikan File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
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