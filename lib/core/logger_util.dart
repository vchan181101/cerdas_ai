import 'package:logger/logger.dart';

/// Utilitas Logging untuk Cerdas AI
/// Membungkus package [logger] dengan konfigurasi standar aplikasi
class LoggerUtil {
  static final Logger _logger = Logger(
    // Hanya tampilkan log jika di mode Debug (Development)
    filter: DevelopmentFilter(),
    printer: PrettyPrinter(
      methodCount: 2, // jumlah baris stacktrace yang ditampilkan
      errorMethodCount: 8, // jumlah baris stacktrace jika terjadi error
      lineLength: 120, // panjang garis pemisah
      colors: true, // aktifkan warna di konsol
      printEmojis: true, // tampilkan emoji sesuai level log
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log untuk informasi teknis mendalam (Trace/Verbose)
  static void trace(dynamic message) => _logger.t(message);

  /// Log untuk keperluan debugging rutin
  static void debug(dynamic message) => _logger.d(message);

  /// Log informasi umum (misal: "Aplikasi dimulai")
  static void info(dynamic message) => _logger.i(message);

  /// Log untuk peringatan yang tidak menghentikan aplikasi (misal: "API lambat")
  static void warning(dynamic message) => _logger.w(message);

  /// Log untuk error kritis
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  /// Log untuk error yang sangat fatal
  static void fatal(dynamic message) => _logger.f(message);
}
