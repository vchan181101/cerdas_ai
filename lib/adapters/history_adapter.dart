import 'package:flutter/material.dart';

import '../models/history_item.dart';
import '../values/colors.dart';

class HistoryAdapter extends StatelessWidget {
  final List<HistoryItem> historyList;
  final ValueChanged<HistoryItem> onItemClick;
  final ValueChanged<HistoryItem>? onDelete;
  final ValueChanged<HistoryItem>? onDownload;

  const HistoryAdapter({
    super.key,
    required this.historyList,
    required this.onItemClick,
    this.onDelete,
    this.onDownload,
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
          onDownload: onDownload != null ? () => onDownload!(item) : null,
        );
      },
    );
  }
}

/// Widget Item Tunggal dengan fitur Custom Slidable (Geser kiri muncul Download & Hapus)
class HistoryItemTile extends StatefulWidget {
  final HistoryItem item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  const HistoryItemTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
    this.onDownload,
  });

  @override
  State<HistoryItemTile> createState() => _HistoryItemTileState();
}

class _HistoryItemTileState extends State<HistoryItemTile> {
  double _dragOffset = 0.0;
  final double _buttonWidth = 80.0;
  late double _maxDragDistance;

  @override
  void initState() {
    super.initState();
    _maxDragDistance = _buttonWidth * 2; // Total width for 2 buttons
  }

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
      // Snapping logic
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
          // Layer Bawah: Tombol Download & Hapus (Akan terlihat saat kartu digeser)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tombol Download
                  GestureDetector(
                    onTap: () {
                      if (widget.onDownload != null) widget.onDownload!();
                      setState(() {
                        _dragOffset = 0;
                      });
                    },
                    child: Container(
                      width: _buttonWidth,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download_rounded, color: Colors.white, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'DOWNLOAD',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 8, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Tombol Hapus
                  GestureDetector(
                    onTap: () {
                      if (widget.onDelete != null) widget.onDelete!();
                      setState(() {
                        _dragOffset = 0;
                      });
                    },
                    child: Container(
                      width: _buttonWidth,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_forever_rounded, color: Colors.white, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'HAPUS',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 8, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
