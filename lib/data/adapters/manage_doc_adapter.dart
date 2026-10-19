import 'package:flutter/material.dart';

import '../models/history_item.dart';
import '../values/colors.dart';

class ManageDocAdapter extends StatelessWidget {
  final List<HistoryItem> docList;
  final bool isSelectionMode;
  final Set<int> selectedPositions;
  final Function(int position) onItemToggleSelect;
  final Function(HistoryItem item)? onItemClick;

  const ManageDocAdapter({
    super.key,
    required this.docList,
    this.isSelectionMode = false,
    required this.selectedPositions,
    required this.onItemToggleSelect,
    this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: docList.length,
      itemBuilder: (context, index) {
        final item = docList[index];
        final isSelected = selectedPositions.contains(index);

        return ManageDocItemTile(
          item: item,
          isSelectionMode: isSelectionMode,
          isSelected: isSelected,
          onTap: () {
            if (isSelectionMode) {
              onItemToggleSelect(index);
            } else if (onItemClick != null) {
              onItemClick!(item);
            }
          },
          onCheckboxChanged: (bool? value) {
            onItemToggleSelect(index);
          },
        );
      },
    );
  }
}

/// Widget Item Tunggal (Konversi dari ViewHolder & item_manage_doc.xml)
class ManageDocItemTile extends StatelessWidget {
  final HistoryItem item;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;

  const ManageDocItemTile({
    super.key,
    required this.item,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onCheckboxChanged,
  });

  // Dynamic styling berdasarkan kategori
  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category.toUpperCase()) {
      case 'PDF':
        return {
          'color': const Color(0xFFEF4444), // Red
          'icon': Icons.picture_as_pdf,
        };
      case 'PPT':
      case 'PPTX':
        return {
          'color': const Color(0xFFF59E0B), // Amber
          'icon': Icons.slideshow,
        };
      case 'EXCEL':
      case 'XLSX':
        return {
          'color': const Color(0xFF10B981), // Emerald Green
          'icon': Icons.table_chart,
        };
      default: // Word / Image / Others
        return {
          'color': const Color(0xFF3B82F6), // Blue
          'icon': Icons.insert_drive_file,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(item.category);
    final Color categoryColor = style['color'];
    final IconData categoryIcon = style['icon'];

    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      elevation: 1,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Icon Kategori Wrapper
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // Title, Category & Timestamp Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.category.toUpperCase()} • ${item.timestamp}',
                      style: TextStyle(
                        fontSize: 12,
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Dynamic CheckBox (Hanya muncul saat Selection Mode Aktif)
              if (isSelectionMode) ...[
                const SizedBox(width: 8),
                Checkbox(
                  value: isSelected,
                  activeColor: AppColors.indigoPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: onCheckboxChanged,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
