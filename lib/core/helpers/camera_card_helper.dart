import 'package:flutter/material.dart';
import '../values/colors.dart';

class CameraCardHelper {
  /// Mengembalikan `BoxDecoration` berdasarkan status scanning
  static BoxDecoration getCardDecoration({required bool isScanning}) {
    if (isScanning) {
      return BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.shade700, // android.R.color.holo_green_dark
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
    } else {
      return BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.inputBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }
  }

  /// Mengembalikan teks status scanner
  static String getStatusText({required bool isScanning}) {
    if (isScanning) {
      return 'Memindai gambar...';
    } else {
      return 'Pindai dokumen atau foto soal...';
    }
  }
}