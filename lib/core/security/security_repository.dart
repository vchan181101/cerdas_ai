import '../core/core.dart';
import 'security_manager.dart';

class SecurityRepository {
  /// Method untuk menjalankan contoh eksekusi SecurityManager
  Future<void> runExampleUsage() async {
    final securityManager = SecurityManager();

    // 1. Menyimpan Token atau Password Terenkripsi
    await securityManager.writeData('AUTH_TOKEN', 'xyz123_secret_token');
    LoggerUtil.info('SecurityManager: Token berhasil disimpan secara terenkripsi.');

    // 2. Membaca Data Terenkripsi
    String? token = await securityManager.readData('AUTH_TOKEN');
    LoggerUtil.info('SecurityManager: Token terenkripsi dibaca -> $token');

    // 3. Hapus Data Saat Logout
    await securityManager.deleteData('AUTH_TOKEN');
    LoggerUtil.info('SecurityManager: Token berhasil dihapus saat logout.');
  }
}