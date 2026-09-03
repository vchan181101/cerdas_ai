import 'dart:io';
import 'package:flutter/material.dart';
import '../../menu/menu.dart';
import '../../values/colors.dart';
import '../../helpers/color/gradient_helper.dart';
import '../../helpers/color/screen_color_helper.dart';
import '../../helpers/color/screen_style_helper.dart';

// ============================================================================
// MODEL & REPOSITORY (Sesuaikan / integrasikan dengan model yang sudah ada)
// ============================================================================

class HistoryItem {
  final String id;
  final String title;
  final String snippet;
  final String? imageUri;
  final int timestampLong;
  bool isInTrash;
  bool isFavorite;

  HistoryItem({
    required this.id,
    required this.title,
    required this.snippet,
    this.imageUri,
    required this.timestampLong,
    this.isInTrash = false,
    this.isFavorite = false,
  });
}

class DocumentRepository {
  static final DocumentRepository _instance = DocumentRepository._internal();
  factory DocumentRepository.getInstance() => _instance;
  DocumentRepository._internal();

  final List<HistoryItem> _items = [];

  List<HistoryItem> getAllItems() => _items;

  void addItem(HistoryItem item) => _items.add(item);

  void moveToTrash(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) _items[index].isInTrash = true;
  }

  void restoreFromTrash(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) _items[index].isInTrash = false;
  }

  void setFavorite(String id, bool favorite) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) _items[index].isFavorite = favorite;
  }
}

// ============================================================================
// MAIN WIDGET: InformasiScreen
// ============================================================================

class InformasiScreen extends StatefulWidget {
  const InformasiScreen({super.key});

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  // State variables
  DateTime _selectedDate = DateTime.now();
  List<HistoryItem> _items = [];
  HistoryItem? _selectedItem;

  // Variabel untuk fitur Undo
  static String? _lastAction;
  static String? _lastItemId;

  // Format & Info info stats
  String _fileSize = "0,90 MB";
  String _fileFormat = "JPG";

  final ScrollController _scrollController = ScrollController();
  final int _currentNavIndex = BottomNavMenu.idGlobal; // Index untuk Informasi Screen

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // LOGIKA DATA & METODE HELPER
  // ==========================================================================

  void _loadData() {
    setState(() {
      _items.clear();
      final allItems = DocumentRepository.getInstance().getAllItems();

      for (var item in allItems) {
        if (item.imageUri != null && !item.isInTrash) {
          final itemDate = DateTime.fromMillisecondsSinceEpoch(item.timestampLong);
          if (itemDate.year == _selectedDate.year &&
              itemDate.month == _selectedDate.month &&
              itemDate.day == _selectedDate.day) {
            _items.add(item);
          }
        }
      }

      if (_items.isNotEmpty) {
        _updatePreview(_items.first);
      } else {
        _selectedItem = null;
      }
    });
  }

  void _updatePreview(HistoryItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  String _formatDateIndonesian(DateTime date) {
    const hari = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    String namaHari = hari[date.weekday - 1];
    String namaBulan = bulan[date.month - 1];
    return '$namaHari, ${date.day} $namaBulan ${date.year}'.toUpperCase();
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: ScreenColorHelper.getPrimaryAction(context),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadData();
    }
  }

  // ==========================================================================
  // ACTION HANDLERS
  // ==========================================================================

  void _handleDelete() {
    if (_selectedItem != null) {
      _lastAction = "DELETE";
      _lastItemId = _selectedItem!.id;
      DocumentRepository.getInstance().moveToTrash(_lastItemId!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item dipindah ke Sampah"),
          duration: Duration(seconds: 2),
        ),
      );
    }
    // Navigasi ke halaman Sampah (ganti dengan rute Sampah Anda)
    // Navigator.pushNamed(context, '/sampah');
  }

  void _handleUndo() {
    if (_lastAction != null && _lastItemId != null) {
      if (_lastAction == "DELETE") {
        DocumentRepository.getInstance().restoreFromTrash(_lastItemId!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Aksi hapus dibatalkan")),
        );
      } else if (_lastAction == "ACCEPT") {
        DocumentRepository.getInstance().setFavorite(_lastItemId!, false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Aksi simpan dibatalkan")),
        );
      }
      _lastAction = null;
      _lastItemId = null;
      _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada aksi untuk dibatalkan")),
      );
    }
  }

  void _handleSkip() {
    if (_items.isNotEmpty && _selectedItem != null) {
      int currentIndex = _items.indexOf(_selectedItem!);
      int nextIndex = (currentIndex + 1) % _items.length;
      _updatePreview(_items[nextIndex]);

      // Scroll thumbnail ke posisi item berikutnya
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          nextIndex * 72.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _handleAccept() {
    if (_selectedItem != null) {
      _lastAction = "ACCEPT";
      _lastItemId = _selectedItem!.id;
      DocumentRepository.getInstance().setFavorite(_lastItemId!, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tersimpan di Favorit"),
          duration: Duration(seconds: 2),
        ),
      );
    }
    // Navigasi ke halaman Kelola Dokumen (ganti dengan rute Anda)
    // Navigator.pushNamed(context, '/kelola_dokumen');
  }

  void _handleProceed() {
    // Navigasi ke Dashboard & finish
    // Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _handleOpenDetail() {
    // Navigasi ke Activity Keterangan / Detail Screen dengan parameter
    Navigator.pushNamed(
      context,
      '/keterangan',
      arguments: {
        'EXTRA_TITLE': _selectedItem?.title,
        'EXTRA_CONTENT': _selectedItem?.snippet,
        'EXTRA_IMAGE_URI': _selectedItem?.imageUri,
        'EXTRA_FILE_SIZE': _fileSize,
        'EXTRA_FILE_FORMAT': _fileFormat,
      },
    );
  }

  // ==========================================================================
  // WIDGET BUILDER
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _selectedItem != null ? _items.indexOf(_selectedItem!) + 1 : 0;
    final String statsCount = "${currentIndex}/${_items.length}";

    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Toolbar
            _buildTopBar(),

            // 2. Horizontal Thumbnail List
            _buildThumbnailList(),

            // 3. Stats Bar (Pills)
            _buildStatsBar(statsCount),

            const SizedBox(height: 12),

            // 4. Main Image Preview Card
            Expanded(child: _buildCardPreview()),

            const SizedBox(height: 12),

            // 5. Bottom Buttons Row (Delete, Undo, Skip, Accept)
            _buildButtonPanel(),

            const SizedBox(height: 12),

            // 6. Keterangan & Proceed Row
            _buildDetailAndProceedRow(),

            const SizedBox(height: 8),
          ],
        ),
      ),
      // 7. Bottom Navigation Bar
      bottomNavigationBar: BottomNavMenu.buildBottomNavigationBar(
        context: context,
        currentIndex: _currentNavIndex,
        onTap: (index) {
          BottomNavMenu.handleNavigation(context, _currentNavIndex, index);
        },
      ),
    );
  }

  // 1. Top Bar Widget
  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Back
          IconButton(
            icon: Icon(Icons.arrow_back, color: ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.7)),
            onPressed: () => Navigator.of(context).maybePop(),
          ),

          // Tanggal (Clickable untuk DatePicker)
          InkWell(
            onTap: _showDatePicker,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                _formatDateIndonesian(_selectedDate),
                style: TextStyle(
                  color: ScreenColorHelper.getHeadingText(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Tombol Menu
          IconButton(
            icon: Icon(Icons.more_vert, color: ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.7)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menu Clicked")),
              );
            },
          ),
        ],
      ),
    );
  }

  // 2. Thumbnail List Widget
  Widget _buildThumbnailList() {
    if (_items.isEmpty) {
      return const SizedBox(height: 64);
    }

    return SizedBox(
      height: 68,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = _items[index];
          final isSelected = item.id == _selectedItem?.id;

          return GestureDetector(
            onTap: () => _updatePreview(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ScreenColorHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? ScreenColorHelper.getPrimaryAction(context) : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageWidget(item.imageUri, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  // 3. Stats Bar Widget
  Widget _buildStatsBar(String statsCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          // Info Icon Pill
          Expanded(
            flex: 1,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: ScreenColorHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.info_outline,
                color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // File Size Pill
          Expanded(
            flex: 2,
            child: _buildPillText(_fileSize),
          ),
          const SizedBox(width: 8),

          // File Format Pill
          Expanded(
            flex: 2,
            child: _buildPillText(_fileFormat),
          ),
          const SizedBox(width: 8),

          // Counter Pill (e.g. 97/265)
          Expanded(
            flex: 2,
            child: _buildPillText(statsCount),
          ),
        ],
      ),
    );
  }

  Widget _buildPillText(String text) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ScreenColorHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ScreenColorHelper.getHeadingText(context),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 4. Card Preview Widget
  Widget _buildCardPreview() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ScreenColorHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _selectedItem != null && _selectedItem!.imageUri != null
            ? _buildImageWidget(_selectedItem!.imageUri, fit: BoxFit.contain)
            : Center(
          child: Icon(
            Icons.image,
            color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.2),
            size: 80,
          ),
        ),
      ),
    );
  }

  // 5. Bottom Action Buttons Row
  Widget _buildButtonPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Delete Button (Merah, 64dp)
        _buildCircleButton(
          size: 64,
          iconSize: 28,
          backgroundColor: const Color(0xFFE53935),
          icon: Icons.delete_outline,
          iconColor: Colors.white,
          onTap: _handleDelete,
        ),
        const SizedBox(width: 20),

        // Undo Button + Label (Dark, 56dp)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCircleButton(
              size: 56,
              iconSize: 24,
              backgroundColor: ScreenColorHelper.getSurfaceColor(context),
              icon: Icons.undo,
              iconColor: ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.7),
              onTap: _handleUndo,
            ),
            const SizedBox(height: 4),
            Text(
              "Undo",
              style: TextStyle(color: ScreenColorHelper.getBodyText(context), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(width: 20),

        // Skip Button + Label (Dark, 56dp)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCircleButton(
              size: 56,
              iconSize: 24,
              backgroundColor: ScreenColorHelper.getSurfaceColor(context),
              icon: Icons.skip_next,
              iconColor: ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.7),
              onTap: _handleSkip,
            ),
            const SizedBox(height: 4),
            Text(
              "Skip",
              style: TextStyle(color: ScreenColorHelper.getBodyText(context), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(width: 20),

        // Accept Button (Hijau, 64dp)
        _buildCircleButton(
          size: 64,
          iconSize: 28,
          backgroundColor: const Color(0xFF00C853),
          icon: Icons.check,
          iconColor: Colors.white,
          onTap: _handleAccept,
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required double size,
    required double iconSize,
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  // 6. Detail Keterangan & Proceed Row
  Widget _buildDetailAndProceedRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Keterangan (Pill Dark)
          ElevatedButton(
            onPressed: _handleOpenDetail,
            style: ElevatedButton.styleFrom(
              backgroundColor: ScreenColorHelper.getSurfaceColor(context),
              foregroundColor: ScreenColorHelper.getHeadingText(context),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.inputBorder.withValues(alpha: 0.1)),
              ),
            ),
            child: const Text(
              "Keterangan",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Tombol PROCEED ->
          InkWell(
            onTap: _handleProceed,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Text(
                    "PROCEED",
                    style: TextStyle(
                      color: ScreenColorHelper.getHeadingText(context),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: ScreenColorHelper.getPrimaryAction(context),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Bottom Navigation Bar Widget (DEPRECATED - Moved to BottomNavMenu)
  Widget _buildBottomNavigationBar() {
    return const SizedBox.shrink();
  }

  // Helper render Image (URL, Local File Path, atau Fallback)
  Widget _buildImageWidget(String? path, {BoxFit fit = BoxFit.cover}) {
    if (path == null || path.isEmpty) {
      return const Icon(Icons.image, color: Colors.white24);
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white24),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(path, fit: fit);
    } else {
      return Image.file(
        File(path),
        fit: fit,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white24),
      );
    }
  }
}