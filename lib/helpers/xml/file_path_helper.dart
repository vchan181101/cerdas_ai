import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart' as of;
import '../../core/core.dart';

// Ekspor agar file lain bisa menggunakan tipe data aslinya
export 'package:open_file/open_file.dart';

/// Helper untuk manajemen path dan operasi file secara aman.
/// Bertujuan menyederhanakan akses ke direktori sistem dan berbagi konten.
class FilePathHelper {
  /// Mendapatkan Direktori Cache Internal (Setara Context.getCacheDir() di Android)
  static Future<Directory> getCacheDirectory() async {
    try {
      return await getTemporaryDirectory();
    } catch (e) {
      LoggerUtil.error('Gagal mendapatkan direktori cache', e);
      rethrow;
    }
  }

  /// Mendapatkan Direktori Dokumen Internal (Setara Context.getFilesDir() di Android)
  static Future<Directory> getInternalFilesDirectory() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      LoggerUtil.error('Gagal mendapatkan direktori dokumen internal', e);
      rethrow;
    }
  }

  /// Mendapatkan Direktori Dukungan Aplikasi (Library/Application Support di iOS)
  static Future<Directory> getAppSupportDirectory() async {
    try {
      return await getApplicationSupportDirectory();
    } catch (e) {
      LoggerUtil.error('Gagal mendapatkan direktori dukungan aplikasi', e);
      rethrow;
    }
  }

  /// Mendapatkan Direktori Eksternal Privat (Setara Context.getExternalFilesDir() di Android)
  static Future<Directory?> getExternalFilesDirectory() async {
    try {
      if (Platform.isAndroid) {
        return await getExternalStorageDirectory();
      }
      return null;
    } catch (e) {
      LoggerUtil.error('Gagal mendapatkan direktori eksternal', e);
      return null;
    }
  }

  /// Membuka file lokal dengan aplikasi eksternal (Konversi dari Intent.ACTION_VIEW)
  static Future<of.OpenResult> openFile(File file) async {
    if (!await file.exists()) {
      LoggerUtil.warning('Percobaan membuka file yang tidak ada: ${file.path}');
      return of.OpenResult()
        ..type = of.ResultType.fileNotFound
        ..message = 'Berkas tidak ditemukan di sistem penyimpanan.';
    }
    
    try {
      return await of.OpenFile.open(file.path);
    } catch (e) {
      LoggerUtil.error('Error saat menjalankan OpenFile', e);
      return of.OpenResult()
        ..type = of.ResultType.error
        ..message = 'Gagal menjalankan aplikasi pembuka berkas.';
    }
  }

  /// Membagikan File ke Aplikasi Lain Menggunakan Safe URI Content
  static Future<void> shareFile({
    required File file,
    String? text,
    String? mimeType,
    String? subject,
  }) async {
    if (!await file.exists()) {
      LoggerUtil.error('Gagal berbagi: File tidak ditemukan di ${file.path}');
      throw Exception('File tidak ditemukan: ${file.path}');
    }

    try {
      final xFile = XFile(file.path, mimeType: mimeType);
      await Share.shareXFiles(
        [xFile],
        text: text,
        subject: subject,
      );
    } catch (e) {
      LoggerUtil.error('Kesalahan saat membagikan berkas', e);
      rethrow;
    }
  }

  /// Menghapus file atau direktori secara rekursif jika diperlukan.
  static Future<bool> deleteItem(FileSystemEntity item, {bool recursive = false}) async {
    try {
      if (await item.exists()) {
        await item.delete(recursive: recursive);
        return true;
      }
      return false;
    } catch (e) {
      LoggerUtil.error('Gagal menghapus item: ${item.path}', e);
      return false;
    }
  }
}
