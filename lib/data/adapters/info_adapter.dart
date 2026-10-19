import 'package:flutter/material.dart';
import '../models/info_document_item.dart';
import '../values/colors.dart';

class InfoAdapter extends StatelessWidget {
  final List<InfoDocumentItem> infoList;
  final Function(InfoDocumentItem item) onItemClick;
  final Function(InfoDocumentItem item) onFavoriteToggle;

  const InfoAdapter({
    super.key,
    required this.infoList,
    required this.onItemClick,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: infoList.length,
      itemBuilder: (context, index) {
        final item = infoList[index];
        return InfoItemTile(
          item: item,
          onTap: () => onItemClick(item),
          onFavoriteTap: () => onFavoriteToggle(item),
        );
      },
    );
  }
}

class InfoItemTile extends StatelessWidget {
  final InfoDocumentItem item;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const InfoItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavoriteTap,
  });

  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category.toUpperCase()) {
      case 'PDF':
        return {'color': Colors.redAccent, 'icon': Icons.picture_as_pdf};
      case 'PPT':
        return {'color': AppColors.tealAccent, 'icon': Icons.slideshow};
      case 'GAMBAR':
      case 'PNG':
      case 'JPG':
        return {'color': Colors.orangeAccent, 'icon': Icons.image};
      case 'WORD':
      case 'DOC':
      case 'DOCX':
        return {'color': AppColors.indigoPrimary, 'icon': Icons.description};
      case 'AUDIO':
        return {'color': Colors.purpleAccent, 'icon': Icons.audiotrack};
      case 'VIDEO':
        return {'color': Colors.blueAccent, 'icon': Icons.videocam};
      default:
        return {'color': AppColors.iconTint, 'icon': Icons.insert_drive_file};
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(item.category);
    final Color iconColor = style['color'];
    final IconData iconData = style['icon'];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '${item.category} • ${item.date}',
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing: IconButton(
          icon: Icon(
            item.isFavorite ? Icons.star : Icons.star_border,
            color: item.isFavorite ? Colors.amber : AppColors.iconTint,
          ),
          onPressed: onFavoriteTap,
        ),
        onTap: onTap,
      ),
    );
  }
}
