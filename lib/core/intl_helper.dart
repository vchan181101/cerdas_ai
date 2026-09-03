import 'package:intl/intl.dart';

/// Helper class untuk manajemen lokalisasi dan format data secara terpusat.
/// Menggunakan package:intl untuk standarisasi di seluruh aplikasi Cerdas AI.
class IntlHelper {
  /// Mendapatkan locale yang saat ini digunakan (Default: Indonesia)
  static String get currentLocale => 'id_ID';

  /// Format Rupiah: 150000 -> Rp150.000
  static String formatCurrency(num amount, {String? symbol = 'Rp', int decimalDigits = 0}) {
    return NumberFormat.currency(
      locale: currentLocale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  /// Format Angka Standar: 1500000 -> 1.500.000
  static String formatNumber(num value) {
    return NumberFormat.decimalPattern(currentLocale).format(value);
  }

  /// Format Tanggal Standar: DateTime.now() -> 28 Agu 2026
  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern, currentLocale).format(date);
  }

  /// Format Waktu Standar: DateTime.now() -> 14:20
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', currentLocale).format(date);
  }

  /// Format Tanggal Lengkap: 28 Agu 2026, 14:20
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', currentLocale).format(date);
  }
}
