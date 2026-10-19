import 'package:flutter/material.dart';
import '../values/colors.dart';

class ColorExampleScreen extends StatelessWidget {
  const ColorExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Color Palette Demo'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks dengan warna Text Primary & Text Muted
            const Text(
              'Judul Utama Cerdas AI',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Deskripsi singkat menggunakan warna text muted yang lembut.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Card / Box Notifikasi Sukses
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.emeraldSuccess),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.emeraldSuccess),
                  SizedBox(width: 12),
                  Text(
                    'Operasi Berhasil Diperbarui',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}