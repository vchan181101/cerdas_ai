import 'package:flutter/material.dart';
import '../models/trash_document_item.dart';
import '../values/colors.dart';

class TrashAdapter extends StatelessWidget {
  final List<TrashDocumentItem> trashList;
  final bool isSelectionMode;
  final Color activeCheckboxColor;
  final Function(TrashDocumentItem item) onItemClick;
  final Function(TrashDocumentItem item) onItemToggleSelect;

  const TrashAdapter({
    super.key,
    required this.trashList,
    this.isSelectionMode = false,
    this.activeCheckboxColor = AppColors.indigoPrimary,
    required this.onItemClick,
    required this.onItemToggleSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trashList.length,
      itemBuilder: (context, index) {
        final item = trashList[index];
        return TrashItemTile(
          item: item,
          isSelectionMode: isSelectionMode,
          activeCheckboxColor: activeCheckboxColor,
          onTap: () => onItemClick(item),
          onToggleSelect: () => onItemToggleSelect(item),
        );
      },
    );
  }
}

class TrashItemTile extends StatelessWidget {
  final TrashDocumentItem item;
  final bool isSelectionMode;
  final Color activeCheckboxColor;
  final VoidCallback onTap;
  final VoidCallback onToggleSelect;

  const TrashItemTile({
    super.key,
    required this.item,
    required this.isSelectionMode,
    required this.activeCheckboxColor,
    required this.onTap,
    required this.onToggleSelect,
  });

  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category.toUpperCase()) {
      case 'PDF':
        return {'color': Colors.redAccent, 'icon': Icons.picture_as_pdf};
      case 'PPT':
        return {'color': AppColors.tealAccent, 'icon': Icons.slideshow};
      case 'EXCEL':
        return {'color': Colors.green, 'icon': Icons.table_chart};
      case 'GAMBAR':
      case 'PNG':
      case 'JPG':
        return {'color': Colors.orangeAccent, 'icon': Icons.image};
      case 'WORD':
      case 'DOC':
      case 'DOCX':
        return {'color': AppColors.indigoPrimary, 'icon': Icons.description};
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
          '${item.category} • Dihapus ${item.date}',
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing: isSelectionMode
            ? Checkbox(
                value: item.isSelected,
                activeColor: activeCheckboxColor,
                onChanged: (_) => onToggleSelect(),
              )
            : null,
        onTap: isSelectionMode ? onToggleSelect : onTap,
      ),
    );
  }
}
