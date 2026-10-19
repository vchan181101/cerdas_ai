import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';
import '../../values/colors.dart';

class SuccessPopExampleScreen extends StatelessWidget {
  const SuccessPopExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Success Pop Animation Demo'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Membungkus Icon/View Sukses dengan SuccessPopAnimationWrapper
            SuccessPopAnimationWrapper(
              duration: const Duration(milliseconds: 700),
              onTap: () {
                debugPrint('Ikon diklik dan animasi Success Pop diputar ulang!');
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.emeraldSuccess.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 72,
                  color: AppColors.emeraldSuccess,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Berhasil!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Ketuk ikon di atas untuk memutar ulang animasi pop'),
          ],
        ),
      ),
    );
  }
}
