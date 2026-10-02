import 'package:flutter/material.dart';
import '../helpers/color/screen_color_helper.dart';
import '../models/history_item.dart';
import '../values/colors.dart';

class HistoryAdapter extends StatelessWidget {
  final List<HistoryItem> historyList;
  final ValueChanged<HistoryItem> onItemClick;
  final ValueChanged<HistoryItem>? onDelete;
  final ValueChanged<HistoryItem>? onDownload;
  final bool enableSlidable;

  const HistoryAdapter({
    super.key,
    required this.historyList,
    required this.onItemClick,
    this.onDelete,
    this.onDownload,
    this.enableSlidable = true,
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
          enableSlidable: enableSlidable,
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
  final bool enableSlidable;

  const HistoryItemTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
    this.onDownload,
    this.enableSlidable = true,
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

  // Dynamic color & icon berdasarkan kategori dan nama file
  Map<String, dynamic> _getCategoryStyle(String category, [String? title]) {
    final catUpper = category.toUpperCase();
    final titleUpper = (title ?? widget.item.title).toUpperCase();

    if (catUpper == 'PDF' || titleUpper.endsWith('.PDF')) {
      return {
        'color': const Color(0xFFEF4444),
        'icon': Icons.picture_as_pdf,
        'label': 'DOKUMEN',
      };
    } else if (catUpper == 'EXCEL' || catUpper == 'XLSX' || catUpper == 'XLS' ||
        titleUpper.endsWith('.XLSX') || titleUpper.endsWith('.XLS')) {
      return {
        'color': const Color(0xFF10B981),
        'icon': Icons.table_chart,
        'label': 'EXCEL',
      };
    } else if (catUpper == 'WORD' || catUpper == 'DOCX' || catUpper == 'DOC' ||
        titleUpper.endsWith('.DOCX') || titleUpper.endsWith('.DOC')) {
      return {
        'color': const Color(0xFF3B82F6),
        'icon': Icons.description,
        'label': 'WORD',
      };
    } else if (catUpper == 'PPT' || catUpper == 'PPTX' ||
        titleUpper.endsWith('.PPTX') || titleUpper.endsWith('.PPT')) {
      return {
        'color': const Color(0xFFEF4444), // In Gambar 2 item 5, PPT is styled red DOKUMEN with slideshow icon
        'icon': Icons.slideshow,
        'label': 'DOKUMEN',
      };
    } else if (catUpper == 'FOTO' || catUpper == 'GAMBAR' ||
        catUpper == 'PNG' || catUpper == 'JPG' || catUpper == 'JPEG' ||
        titleUpper.endsWith('.PNG') || titleUpper.endsWith('.JPG') || titleUpper.endsWith('.JPEG') || titleUpper.endsWith('.WEBP')) {
      return {
        'color': const Color(0xFFF97316),
        'icon': Icons.image,
        'label': 'FOTO',
      };
    } else if (catUpper == 'BELAJAR') {
      return {
        'color': const Color(0xFF10B981),
        'icon': Icons.school_outlined,
        'label': 'BELAJAR',
      };
    } else if (catUpper == 'TANYA' || catUpper == 'TEKS') {
      return {
        'color': const Color(0xFF3B82F6),
        'icon': Icons.question_answer_outlined,
        'label': 'TANYA',
      };
    } else if (catUpper == 'DOKUMEN') {
      return {
        'color': const Color(0xFFEF4444),
        'icon': Icons.description,
        'label': 'DOKUMEN',
      };
    } else {
      return {
        'color': const Color(0xFF6B7280),
        'icon': Icons.insert_drive_file,
        'label': category.toUpperCase(),
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
    final String categoryLabel = style['label'] ?? widget.item.category.toUpperCase();
    final surfaceColor = ScreenColorHelper.getSurfaceColor(context);
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);

    final cardWidget = Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.inputBorder.withValues(alpha: 0.15),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (widget.enableSlidable && _dragOffset != 0) {
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
                          categoryLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                        Text(
                          widget.item.timestamp,
                          style: TextStyle(
                            fontSize: 12,
                            color: bodyColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: headingColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.item.snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: bodyColor.withValues(alpha: 0.7),
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

    if (!widget.enableSlidable) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        child: cardWidget,
      );
    }

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
              child: cardWidget,
            ),
          ),
        ],
      ),
    );
  }
}
