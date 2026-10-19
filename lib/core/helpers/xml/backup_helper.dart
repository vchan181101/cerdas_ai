import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupHelper {
  // Safe Storage (Secured & Excluded from Cloud Backup via EncryptedSharedPreferences)
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // 1. Simpan Data Sensitif (Dikecualikan dari Auto-Backup)
  static Future<void> saveSecureCredential(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecureCredential(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Alias untuk kompatibilitas
  static Future<void> saveSecureToken(String token) async =>
      saveSecureCredential('user_auth_token', token);

  static Future<String?> getSecureToken() async =>
      getSecureCredential('user_auth_token');

  static Future<void> clearSecureData() async {
    await _secureStorage.deleteAll();
  }

  // 2. Simpan Data Umum (Disertakan dalam Auto-Backup: Tema, Bahasa, Setting)
  static Future<void> saveUserPreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getUserPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // 3. Kelola File Sementara / Temporary Files (Kategori Exclude Cache)
  static Future<File> createTempFile(String fileName, String content) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    return await tempFile.writeAsString(content);
  }

  static Future<void> clearCacheAndTempFiles() async {
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  // Alias untuk kompatibilitas
  static Future<void> clearTempFiles() async => clearCacheAndTempFiles();
}
