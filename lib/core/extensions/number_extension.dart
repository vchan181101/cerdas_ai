import 'package:intl/intl.dart';

/// Extension untuk mempermudah pemformatan angka dan mata uang menggunakan package:intl
extension NumberExtension on num {
  /// Format Mata Uang Rupiah standar: Rp150.000
  String get toRupiah {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(this);
  }

  /// Format Mata Uang Rupiah dengan spasi: Rp 150.000
  String get toRupiahSpaced {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }

  /// Format Angka dengan pemisah ribuan (Locale Indonesia): 1.500.000
  String get toFormattedNumber {
    return NumberFormat.decimalPattern('id_ID').format(this);
  }

  /// Format Angka Ringkas (Compact): 1,2 jt atau 10 rb
  String get toCompact {
    return NumberFormat.compact(locale: 'id_ID').format(this);
  }

  /// Format Angka Ringkas untuk Mata Uang: Rp1,2jt
  String get toCompactCurrency {
    return NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(this);
  }

  /// Konversi ukuran byte ke format yang mudah dibaca (KB, MB, GB, dll)
  String get toFileSize {
    if (this <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB"];
    var i = 0;
    var size = toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    // Jika angka bulat, hilangkan .0
    if (size % 1 == 0) {
      return "${size.toInt()} ${suffixes[i]}";
    }
    return "${size.toStringAsFixed(1)} ${suffixes[i]}";
  }

  /// Format Persentase: 0.15 -> 15%
  String get toPercentage {
    return NumberFormat.percentPattern().format(this);
  }
}
