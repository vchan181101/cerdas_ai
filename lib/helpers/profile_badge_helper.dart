import 'package:flutter/material.dart';
import '../values/colors.dart';

class ProfileBadgeHelper {
  /// Menampilkan dialog/bottom sheet opsi penggantian foto profil
  /// Menggantikan `setupBadgeClickListener` di Android Java
  static void showAvatarOptions(BuildContext context, {VoidCallback? onPickGallery, VoidCallback? onTakePhoto}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ubah Foto Profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.indigoPrimary),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () {
                    Navigator.pop(ctx);
                    if (onPickGallery != null) {
                      onPickGallery();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Buka opsi galeri...')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.indigoPrimary),
                  title: const Text('Ambil Foto Kamera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    if (onTakePhoto != null) {
                      onTakePhoto();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Buka opsi kamera...')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper widget untuk membuat ikon badge pensil/kamera di atas Avatar
  Widget buildEditableAvatarBadge({
    required Widget avatarWidget,
    required VoidCallback onTap,
  }) {
    return Stack(
      children: [
        avatarWidget,
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.indigoPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}