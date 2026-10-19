import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';
import '../../values/colors.dart';

class BounceExampleScreen extends StatelessWidget {
  const BounceExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Bounce Animation Demo'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BounceAnimationWrapper(
              duration: const Duration(milliseconds: 1200),
              onTap: () {
                debugPrint('Logo diklik dan animasi bounce diputar!');
              },
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: AppColors.indigoPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Ketuk ikon di atas untuk memutar ulang animasi bounce'),
          ],
        ),
      ),
    );
  }
}
