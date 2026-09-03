import 'package:flutter/material.dart';

import '../../adapters/history_adapter.dart';
import '../../helpers/color/color_helper.dart';
import '../../menu/menu.dart';
import '../../models/history_item.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../widgets/bottom_navigation_view_widget.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Tag Filter Aktif: 'semua', 'dokumen', 'foto', 'teks'
  String _activeFilter = 'semua';
  final int _currentBottomNavIndex = 1; // Index 1 untuk Aktivitas

  // Master Dataset Simulasi Riwayat menggunakan model bersama
  final List<HistoryItem> _allHistoryList = [
    HistoryItem(
      id: '1',
      title: 'Ringkasan Laporan Keuangan Q3 2025.pdf',
      timestamp: '24 Agu 2026, 14:20',
      category: 'dokumen',
      snippet: 'Analisis profitabilitas dan arus kas kuartal ketiga.',
    ),
    HistoryItem(
      id: '2',
      title: 'Analisis Diagram Arsitektur Cloud.png',
      timestamp: '24 Agu 2026, 11:05',
      category: 'foto',
      snippet: 'Deteksi komponen AWS Lambda dan S3 Bucket.',
    ),
    HistoryItem(
      id: '3',
      title: 'Bagaimana cara kerja algoritma Support Vector Machine?',
      timestamp: '23 Agu 2026, 09:15',
      category: 'teks',
      snippet: 'Penjelasan mengenai hyperplane dan margin maksimal.',
    ),
    HistoryItem(
      id: '4',
      title: 'Draft Proposal Proyek Imperial World Kingdom.docx',
      timestamp: '22 Agu 2026, 16:45',
      category: 'dokumen',
      snippet: 'Rencana pengembangan kawasan residensial pintar.',
    ),
    HistoryItem(
      id: '5',
      title: 'Foto Papan Tulis Rapat Karang Taruna',
      timestamp: '20 Agu 2026, 19:30',
      category: 'foto',
      snippet: 'Hasil diskusi kegiatan bakti sosial warga.',
    ),
  ];

  List<HistoryItem> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(_allHistoryList);
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      _filteredList = _allHistoryList.where((item) {
        final matchesQuery = item.title.toLowerCase().contains(query);
        final matchesFilter = _activeFilter == 'semua' || item.category == _activeFilter;
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _clearAllHistory() {
    if (_allHistoryList.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text('Tindakan ini akan menghapus seluruh catatan aktivitas Anda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allHistoryList.clear();
                _filteredList.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seluruh riwayat berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _handleItemClick(HistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Membuka: ${item.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 28),
                        Text(
                          AppStrings.titleAktivitas,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ScreenColorHelper.getHeadingText(context),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: ScreenColorHelper.getBodyText(context), size: 28),
                          tooltip: AppStrings.actionHapus,
                          onPressed: _clearAllHistory,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _searchController,
                      style: TextStyle(fontSize: 14, color: ScreenColorHelper.getHeadingText(context)),
                      decoration: InputDecoration(
                        hintText: AppStrings.hintSearchRiwayat,
                        hintStyle: TextStyle(color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5), fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: ScreenColorHelper.getBodyText(context)),
                        filled: true,
                        fillColor: ScreenColorHelper.getSurfaceColor(context),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.inputBorder.withValues(alpha: 0.3), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: ScreenColorHelper.getPrimaryAction(context), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(label: AppStrings.filterSemua, filterKey: 'semua'),
                          const SizedBox(width: 8),
                          _buildFilterChip(label: AppStrings.filterDokumen, filterKey: 'dokumen'),
                          const SizedBox(width: 8),
                          _buildFilterChip(label: AppStrings.filterFoto, filterKey: 'foto'),
                          const SizedBox(width: 8),
                          _buildFilterChip(label: AppStrings.filterTeks, filterKey: 'teks'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _filteredList.isEmpty
                          ? Center(
                              child: Text(
                                'Tidak ada riwayat aktivitas ditemukan',
                                style: TextStyle(color: ScreenColorHelper.getBodyText(context), fontSize: 14),
                              ),
                            )
                          : SingleChildScrollView(
                              child: HistoryAdapter(
                                historyList: _filteredList,
                                onItemClick: _handleItemClick,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationViewWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          BottomNavMenu.handleNavigation(context, _currentBottomNavIndex, index);
        },
      ),
    );
  }

  Widget _buildFilterChip({required String label, required String filterKey}) {
    final bool isActive = _activeFilter == filterKey;
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = filterKey;
          _applyFilters();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : ScreenColorHelper.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? primaryColor : AppColors.inputBorder.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : ScreenColorHelper.getHeadingText(context),
          ),
        ),
      ),
    );
  }
}
