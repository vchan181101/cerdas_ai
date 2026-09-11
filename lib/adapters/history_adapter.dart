import 'package:flutter/material.dart';

import '../models/history_item.dart';
import '../values/colors.dart';

class HistoryAdapter extends StatelessWidget {
  final List<HistoryItem> historyList;
  final ValueChanged<HistoryItem> onItemClick;
  final ValueChanged<HistoryItem>? onDelete;

  const HistoryAdapter({
    super.key,
    required this.historyList,
    required this.onItemClick,
    this.onDelete,
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
          onDelete: onDelete != null ? () => onDelete!(item) : null,
        );
      },
    );
  }
}

/// Widget Item Tunggal dengan fitur Custom Slidable (Geser kiri muncul hapus)
class HistoryItemTile extends StatefulWidget {
  final HistoryItem item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const HistoryItemTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<HistoryItemTile> createState() => _HistoryItemTileState();
}

class _HistoryItemTileState extends State<HistoryItemTile> {
  double _dragOffset = 0.0;
  final double _maxDragDistance = 100.0; // Lebar area tombol hapus

  // Dynamic color & icon berdasarkan kategori
  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category.toUpperCase()) {
      case 'DOKUMEN':
      case 'PDF':
        return {
          'color': const Color(0xFFEF4444),
          'icon': Icons.picture_as_pdf,
        };
      case 'BELAJAR':
      case 'FOTO':
      case 'GAMBAR':
        return {
          'color': const Color(0xFF10B981),
          'icon': Icons.school_outlined,
        };
      case 'TANYA':
      case 'TEKS':
        return {
          'color': const Color(0xFF3B82F6),
          'icon': Icons.question_answer_outlined,
        };
      case 'PPT':
        return {
          'color': const Color(0xFFF59E0B),
          'icon': Icons.slideshow,
        };
      default:
        return {
          'color': const Color(0xFF6B7280),
          'icon': Icons.history_rounded,
        };
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      // Batasi: hanya bisa geser ke kiri (negatif), maksimal sejauh _maxDragDistance
      if (_dragOffset < -_maxDragDistance) {
        _dragOffset = -_maxDragDistance;
      } else if (_dragOffset > 0) {
        _dragOffset = 0;
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      // Snapping logic: Jika geser cukup jauh, tetap buka. Jika tidak, tutup kembali.
      if (_dragOffset < -(_maxDragDistance / 2)) {
        _dragOffset = -_maxDragDistance;
      } else {
        _dragOffset = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(widget.item.category);
    final Color categoryColor = style['color'];
    final IconData categoryIcon = style['icon'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Stack(
        children: [
          // Layer Bawah: Tombol Hapus (Akan terlihat saat kartu digeser)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  if (widget.onDelete != null) widget.onDelete!();
                  setState(() {
                    _dragOffset = 0; // Tutup kembali setelah klik hapus
                  });
                },
                child: Container(
                  width: _maxDragDistance,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever_rounded, color: Colors.white, size: 28),
                        SizedBox(height: 4),
                        Text(
                          'HAPUS',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 10, 
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Layer Atas: Kartu Konten
          GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_dragOffset, 0, 0),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 1,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // Jika sedang terbuka, klik kartu akan menutup kembali
                    if (_dragOffset != 0) {
                      setState(() => _dragOffset = 0);
                    } else {
                      widget.onTap();
                    }
                  },
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
                            color: categoryColor.withOpacity(0.12),
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
                                    widget.item.category.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: categoryColor,
                                    ),
                                  ),
                                  Text(
                                    widget.item.timestamp,
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
                                widget.item.title,
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
                                widget.item.snippet,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
