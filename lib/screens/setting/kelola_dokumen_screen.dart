import 'package:flutter/material.dart';

import '../../adapters/manage_doc_adapter.dart';
import '../../models/history_item.dart';
import '../../values/colors.dart';

class KelolaDokumenScreen extends StatefulWidget {
  const KelolaDokumenScreen({super.key});

  @override
  State<KelolaDokumenScreen> createState() => _KelolaDokumenScreenState();
}

class _KelolaDokumenScreenState extends State<KelolaDokumenScreen> {
  // Master Repository Data Dokumen menggunakan model HistoryItem
  final List<HistoryItem> _masterDocs = [
    HistoryItem(
      id: '1',
      title: 'Laporan Keuangan Q3 2026.pdf',
      timestamp: '24 Agu 2026',
      category: 'PDF',
      snippet: 'Laporan laba rugi dan neraca kuartal ketiga.',
      isFavorite: true,
    ),
    HistoryItem(
      id: '2',
      title: 'Presentasi Proyek Imperial World Kingdom.pptx',
      timestamp: '23 Agu 2026',
      category: 'PPT',
      snippet: 'Slide presentasi rencana pembangunan kawasan.',
    ),
    HistoryItem(
      id: '3',
      title: 'Rekapitulasi Anggaran Bulanan.xlsx',
      timestamp: '21 Agu 2026',
      category: 'EXCEL',
      snippet: 'Detail pengeluaran operasional tim.',
      isFavorite: true,
    ),
    HistoryItem(
      id: '4',
      title: 'Foto Kegiatan Karang Taruna Penggilingan.png',
      timestamp: '20 Agu 2026',
      category: 'GAMBAR',
      snippet: 'Dokumentasi bakti sosial bulan kemerdekaan.',
    ),
    HistoryItem(
      id: '5',
      title: 'Panduan Penulisan Skripsi.docx',
      timestamp: '18 Agu 2026',
      category: 'WORD',
      snippet: 'Petunjuk teknis format penulisan tugas akhir.',
    ),
  ];

  List<HistoryItem> _displayDocs = [];
  bool _isSelectionMode = false;
  String _activeCategoryFilter = 'ALL';
  final Set<int> _selectedPositions = {};

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _isSelectionMode = false;
      _activeCategoryFilter = 'ALL';
      _displayDocs = List.from(_masterDocs);
      _selectedPositions.clear();
    });
  }

  void _filterByType(String type) {
    setState(() {
      _activeCategoryFilter = type;
      _displayDocs = _masterDocs.where((item) {
        if (type == 'GAMBAR') {
          return item.category == 'GAMBAR' || item.category == 'PNG' || item.category == 'JPG';
        }
        return item.category.toUpperCase() == type.toUpperCase();
      }).toList();
      _selectedPositions.clear();
    });
  }

  void _filterFavorit() {
    setState(() {
      _activeCategoryFilter = 'FAVORIT';
      _displayDocs = _masterDocs.where((item) => item.isFavorite).toList();
      _selectedPositions.clear();
    });
  }

  void _showTerbaruMenu(BuildContext context, TapDownDetails details) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(value: 'Tanggal', child: Text('Tanggal')),
        PopupMenuItem(value: 'Bulan', child: Text('Bulan')),
        PopupMenuItem(value: 'Tahun', child: Text('Tahun')),
      ],
    ).then((value) {
      if (value != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filter berdasarkan $value')),
        );
      }
    });
  }

  void _showJenisMenu(BuildContext context, TapDownDetails details) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final types = ["PDF", "PPT", "EXCEL", "GAMBAR", "VIDEO", "AUDIO", "WORD"];

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: types.map((type) => PopupMenuItem(value: type, child: Text(type))).toList(),
    ).then((selectedType) {
      if (selectedType != null) {
        _filterByType(selectedType);
      }
    });
  }

  void _showOptionsMenu(BuildContext context, TapDownDetails details) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(value: 'Share', child: Text('Share')),
        PopupMenuItem(value: 'Delete', child: Text('Delete')),
        PopupMenuItem(value: 'Rename', child: Text('Rename')),
        PopupMenuItem(value: 'Download', child: Text('Download')),
      ],
    ).then((choice) {
      if (choice == null || !context.mounted) return;
      switch (choice) {
        case 'Share':
          _showShareMenu();
          break;
        case 'Delete':
          _enterDeleteMode();
          break;
        case 'Rename':
          _enterRenameMode();
          break;
        case 'Download':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dokumen berhasil diunduh ke ponsel')),
          );
          break;
      }
    });
  }

  void _showShareMenu() {
    final apps = ["Facebook", "Instagram", "Whatsapp", "Line", "Wechat", "Gmail", "Gdrive", "Tiktok"];
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Bagikan ke...'),
        children: apps
            .map(
              (app) => SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Berhasil dibagikan ke $app')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(app, style: const TextStyle(fontSize: 15)),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  void _enterDeleteMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedPositions.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pilih file yang ingin dihapus')),
    );
  }

  void _enterRenameMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedPositions.clear();
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: const Text('Pilih tepat satu file dan masukkan nama baru.'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isSelectionMode = false);
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_selectedPositions.length == 1) {
                _showRenameInputDialog(_displayDocs[_selectedPositions.first]);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih tepat satu file')),
                );
                setState(() => _isSelectionMode = false);
              }
            },
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  void _showRenameInputDialog(HistoryItem item) {
    final controller = TextEditingController(text: item.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nama Baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isSelectionMode = false);
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  item.title = controller.text.trim();
                  _isSelectionMode = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama berhasil diubah')),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _performDeleteSelected() {
    if (_selectedPositions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada file dipilih')),
      );
      return;
    }

    setState(() {
      final List<HistoryItem> itemsToRemove = [];
      for (int pos in _selectedPositions) {
        itemsToRemove.add(_displayDocs[pos]);
      }
      _masterDocs.removeWhere((doc) => itemsToRemove.contains(doc));
      _isSelectionMode = false;
      _refreshData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File berhasil dipindahkan ke sampah')),
    );
  }

  void _toggleSelection(int position) {
    setState(() {
      if (_selectedPositions.contains(position)) {
        _selectedPositions.remove(position);
      } else {
        _selectedPositions.add(position);
      }
    });
  }

  void _handleItemClick(HistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Membuka: ${item.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/setting');
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Kelola Dokumen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTapDown: (details) => _showTerbaruMenu(context, details),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Terbaru',
                              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTapDown: (details) => _showJenisMenu(context, details),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _activeCategoryFilter != 'ALL' && _activeCategoryFilter != 'FAVORIT'
                                  ? _activeCategoryFilter
                                  : 'Jenis',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: _filterFavorit,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: Text(
                            'Favorit',
                            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTapDown: (details) => _showOptionsMenu(context, details),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _displayDocs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.folder_off_outlined, size: 48, color: Color(0xFF94A3B8)),
                          SizedBox(height: 12),
                          Text(
                            'Tidak ada dokumen ditemukan',
                            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: ManageDocAdapter(
                        docList: _displayDocs,
                        isSelectionMode: _isSelectionMode,
                        selectedPositions: _selectedPositions,
                        onItemToggleSelect: _toggleSelection,
                        onItemClick: _handleItemClick,
                      ),
                    ),
            ),
            if (_isSelectionMode)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isSelectionMode = false;
                            _selectedPositions.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFF64748B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _performDeleteSelected,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
