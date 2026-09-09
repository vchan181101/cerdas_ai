import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/helpers.dart';
import '../values/values.dart';

/// Widget untuk menampilkan pratinjau berkas dengan opsi Buka & Bagikan.
/// Diperbarui untuk mendukung standar modern Cerdas AI.
class FilePreviewWidget extends StatelessWidget {
  final String fileName;
  final String? category;

  const FilePreviewWidget({
    super.key,
    required this.fileName,
    this.category,
  });

  /// Mendapatkan instance File dari direktori lokal aplikasi
  Future<File> _getLocalFile() async {
    final dir = await FilePathHelper.getInternalFilesDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    // Simulasi: Buat file dummy jika belum ada di storage
    if (!await file.exists()) {
      await file.writeAsString('Konten Dokumen Cerdas AI - $fileName');
    }
    return file;
  }

  /// Menangani pembukaan berkas menggunakan aplikasi eksternal (Intent)
  Future<void> _handleOpenFile(BuildContext context) async {
    try {
      final file = await _getLocalFile();
      final result = await FilePathHelper.openFile(file);

      // PERBAIKAN: Gunakan pola guard clause untuk mengecek mounted context secara modern
      if (!context.mounted) return;

      // Jika gagal membuka (ResultType selain DONE), tampilkan feedback snackbar
      if (result.type != ResultType.done) {
        context.showSnackBar('Gagal membuka berkas: ${result.message}');
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar('Terjadi kesalahan saat membuka: $e');
      }
    }
  }

  /// Menangani pembagian berkas ke aplikasi lain (Share Intent)
  Future<void> _handleShareFile(BuildContext context) async {
    try {
      final file = await _getLocalFile();
      await FilePathHelper.shareFile(
        file: file,
        subject: 'Dokumen Cerdas AI',
        text: 'Bagikan berkas: $fileName via Cerdas AI',
      );
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar('Gagal membagikan berkas: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.successLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.description_rounded, color: AppColors.emeraldSuccess, size: 28),
        ),
        title: Text(
          fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          category ?? 'Dokumen AI',
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              icon: Icons.open_in_new_rounded,
              color: Colors.blue,
              tooltip: 'Buka',
              onTap: () => _handleOpenFile(context),
            ),
            const SizedBox(width: 4),
            _buildActionButton(
              icon: Icons.share_rounded,
              color: AppColors.emeraldSuccess,
              tooltip: 'Bagikan',
              onTap: () => _handleShareFile(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk membangun tombol aksi kecil di sisi kanan
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20),
      tooltip: tooltip,
      onPressed: onTap,
      splashRadius: 24,
    );
  }
}
