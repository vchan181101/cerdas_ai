import 'package:intl/date_symbol_data_local.dart';
import 'core/core.dart';

/// Fungsi terpusat untuk menginisialisasi format tanggal dan lokalisasi aplikasi.
/// Dipanggil di main.dart sebelum runApp().
Future<void> initializeAppDateFormatting() async {
  try {
    // Inisialisasi data simbol tanggal untuk Bahasa Indonesia (id_ID)
    await initializeDateFormatting('id_ID', null);
    
    LoggerUtil.info("Inisialisasi format tanggal Indonesia (id_ID) berhasil.");
  } catch (e) {
    // Logging jika terjadi kegagalan (jarang terjadi namun penting untuk ditangani)
    LoggerUtil.error("Gagal menginisialisasi format tanggal:", e);
  }
}
