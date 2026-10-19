import 'package:flutter/material.dart';
import '../../widgets/circular_image_view.dart';
import '../../values/colors.dart';

class ProfileImageExampleScreen extends StatelessWidget {
  const ProfileImageExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular ImageView Demo'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Ukuran Standar (Tanpa Border)
            const CircularImageView(
              imagePath: 'assets/images/img_profile.jpg',
              size: 88,
            ),
            const SizedBox(height: 24),

            // 2. Dengan Border & Efek Shadow
            const CircularImageView(
              imagePath: 'assets/images/img_profile.jpg',
              size: 100,
              borderColor: AppColors.indigoPrimary,
              borderWidth: 3.0,
            ),
            const SizedBox(height: 24),

            // 3. Ukuran Kecil (Thumbnails)
            const CircularImageView(
              imagePath: 'assets/images/img_profile.jpg',
              size: 48,
              borderColor: Colors.grey,
              borderWidth: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}
