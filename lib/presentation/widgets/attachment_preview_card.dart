import 'dart:io';
import 'package:flutter/material.dart';
import '../values/colors.dart';

class AttachmentPreviewCard extends StatelessWidget {
  final File? file;
  final String? imagePath;
  final bool isNetwork;
  final String fileName;
  final IconData icon;
  final bool isImage;
  final VoidCallback onRemove;

  const AttachmentPreviewCard({
    super.key,
    this.file,
    this.imagePath,
    this.isNetwork = false,
    required this.fileName,
    required this.icon,
    this.isImage = false,
    required this.onRemove,
  });

  Widget _buildThumbnail() {
    if (file != null) {
      return Image.file(
        file!,
        fit: BoxFit.cover,
      );
    }
    if (imagePath != null && imagePath!.isNotEmpty) {
      final bool isNet = isNetwork ||
          imagePath!.startsWith('http://') ||
          imagePath!.startsWith('https://');
      if (isNet) {
        return Image.network(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 20),
        );
      }
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 20),
      );
    }
    return Icon(icon, color: AppColors.indigoPrimary);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildThumbnail(),
                  )
                : Icon(icon, color: AppColors.indigoPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
