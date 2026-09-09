import 'package:flutter/material.dart';

import '../../adapters/history_adapter.dart';
import '../../helpers/helpers.dart';
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

  void _handleItemClick(HistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${AppStrings.menuInformasi}: ${item.title}')),
    );
  }

  void _handleDeleteItem(HistoryItem item) {
    setState(() {
      _allHistoryList.removeWhere((element) => element.id == item.id);
      _applyFilters();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Riwayat "${item.title}" dihapus'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allHistoryList.add(item);
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.titleAktivitas,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: headingColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _searchController,
                      style: TextStyle(fontSize: 14, color: headingColor),
                      decoration: InputDecoration(
                        hintText: AppStrings.hintSearchRiwayat,
                        hintStyle: TextStyle(color: bodyColor.withValues(alpha: 0.5), fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: bodyColor),
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
                                style: TextStyle(color: bodyColor, fontSize: 14),
                              ),
                            )
                          : SingleChildScrollView(
                              child: HistoryAdapter(
                                historyList: _filteredList,
                                onItemClick: _handleItemClick,
                                onDelete: _handleDeleteItem,
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
