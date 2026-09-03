import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  /// Locale default untuk semua format (bisa diganti secara global)
  static String defaultLocale = 'id_ID';

  /// Format standar: 26 Agt 2026
  String get toFormattedString {
    return DateFormat('dd MMM yyyy', defaultLocale).format(this);
  }

  /// Format lengkap dengan waktu: 26 Agt 2026, 14:20
  String get toFormattedStringWithTime {
    return DateFormat('dd MMM yyyy, HH:mm', defaultLocale).format(this);
  }

  /// Format jam saja: 14:20
  String get toTimeOnly {
    return DateFormat('HH:mm', defaultLocale).format(this);
  }

  /// Format Hari dan Bulan: 26 Agustus
  String get toDayMonthName {
    return DateFormat('dd MMMM', defaultLocale).format(this);
  }

  /// Mendapatkan nama hari: Senin, Selasa, dst.
  String get toDayName {
    return DateFormat('EEEE', defaultLocale).format(this);
  }

  /// Cek apakah tanggal hari ini
  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }

  /// Cek apakah tanggal kemarin
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Cek apakah tahun ini
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// Membandingkan apakah hari, bulan, dan tahun sama
  bool isSameDay(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  /// Format "Manusiawi" (Smart Date)
  /// Contoh: "Hari ini, 14:20", "Kemarin, 14:20", atau "20 Agu 2026"
  String get toHumanReadable {
    if (isToday) {
      return 'Hari ini, $toTimeOnly';
    } else if (isYesterday) {
      return 'Kemarin, $toTimeOnly';
    } else if (isThisYear) {
      return DateFormat('dd MMM, HH:mm', defaultLocale).format(this);
    } else {
      return toFormattedString;
    }
  }

  /// Format durasi waktu berlalu (Time Ago)
  /// Contoh: "5 menit lalu", "2 jam lalu"
  String get timeAgo {
    final difference = DateTime.now().difference(this);

    // Tangani jika tanggal ada di masa depan
    if (difference.isNegative) {
      return 'Baru saja';
    }

    if (difference.inDays > 30) {
      return toFormattedString;
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}
