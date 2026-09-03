import 'package:flutter/material.dart';

import '../models/history_item.dart';
import '../values/colors.dart';

class HistoryAdapter extends StatelessWidget {
  final List<HistoryItem> historyList;
  final ValueChanged<HistoryItem> onItemClick;

  const HistoryAdapter({
    super.key,
    required this.historyList,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        final item = historyList[index];
        return HistoryItemTile(
          item: item,
          onTap: () => onItemClick(item),
        );
      },
    );
  }
}

/// Widget Item Tunggal (Konversi dari ViewHolder & item_riwayat.xml)
class HistoryItemTile extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;

  const HistoryItemTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  // Dynamic color & icon berdasarkan kategori
  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category.toUpperCase()) {
      case 'DOKUMEN':
      case 'PDF':
        return {
          'color': const Color(0xFFEF4444), // Red
          'icon': Icons.picture_as_pdf,
        };
      case 'FOTO':
      case 'GAMBAR':
        return {
          'color': const Color(0xFF10B981), // Green
          'icon': Icons.photo_library,
        };
      case 'PPT':
        return {
          'color': const Color(0xFFF59E0B), // Amber/Orange
          'icon': Icons.slideshow,
        };
      default: // Teks
        return {
          'color': const Color(0xFF3B82F6), // Blue
          'icon': Icons.send,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(item.category);
    final Color categoryColor = style['color'];
    final IconData categoryIcon = style['icon'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container Icon Kategori
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // Detail Konten Riwayat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row Label Kategori & Timestamp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                        Text(
                          item.timestamp,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Title / Judul Riwayat
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Snippet / Ringkasan Isi
                    Text(
                      item.snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
