import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataExtractionHelper {
  // Storage terenkripsi yang sesuai dengan kriteria exclude pada data_extraction_rules.xml
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // 1. Simpan Data Sensitif (Otomatis Dikecualikan oleh rule XML)
  static Future<void> setSecureSession(String key, String secretValue) async {
    await _secureStorage.write(key: key, value: secretValue);
  }

  static Future<String?> getSecureSession(String key) async {
    return await _secureStorage.read(key: key);
  }

  // 2. Simpan Preferensi Umum (Diizinkan ter-backup / transfer D2D)
  static Future<void> setAppPreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getAppPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // 3. Kelola Berkas Sementara di Temporary Directory
  static Future<File> writeTempFile(String fileName, String content) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    return await file.writeAsString(content);
  }

  static Future<void> purgeTempFiles() async {
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      tempDir.deleteSync(recursive: true);
    }
  }
}