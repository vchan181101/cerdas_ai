import 'dart:io';
import 'package:flutter/material.dart';
import '../values/colors.dart';

class AttachmentPreviewCard extends StatelessWidget {
  final File file;
  final String fileName;
  final IconData icon;
  final bool isImage;
  final VoidCallback onRemove;

  const AttachmentPreviewCard({
    super.key,
    required this.file,
    required this.fileName,
    required this.icon,
    this.isImage = false,
    required this.onRemove,
  });

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
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
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
