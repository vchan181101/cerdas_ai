import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../helpers/profile_badge_helper.dart';
import '../../values/colors.dart';

class ProfileAvatarDemoScreen extends StatelessWidget {
  const ProfileAvatarDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Memasang Badge Avatar menggunakan Helper
            ProfileBadgeHelper().buildEditableAvatarBadge(
              avatarWidget: const CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.white,
                child: Icon(Icons.person, size: 60, color: AppColors.iconTint),
              ),
              onTap: () {
                // Panggil Bottom Sheet Pilihan Kamera/Galeri
                ProfileBadgeHelper.showAvatarOptions(context);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Tekan ikon kamera untuk mengganti foto',
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
