import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../adapters/history_adapter.dart';
import '../../core/app_constants.dart';
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

  // Tag Filter Aktif: 'semua', 'dokumen', 'belajar', 'tanya'
  String _activeFilter = 'semua';
  final int _currentBottomNavIndex = 1; // Index 1 untuk Aktivitas

  // Master Dataset
  final List<HistoryItem> _allHistoryList = [];
  List<HistoryItem> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _loadInitialData() async {
    // 1. Tambahkan Data Simulasi Default
    _allHistoryList.addAll([
      HistoryItem(
        id: 'sim_1',
        title: 'Ringkasan Laporan Keuangan Q3 2025.pdf',
        timestamp: '24 Agu 2026, 14:20',
        category: 'dokumen',
        snippet: 'Analisis profitabilitas dan arus kas kuartal ketiga.',
      ),
      HistoryItem(
        id: 'sim_2',
        title: 'Biologi: Struktur Sel Manusia',
        timestamp: '24 Agu 2026, 11:05',
        category: 'belajar',
        snippet: 'Materi kartu pembelajaran mengenai komponen sel dan organel.',
      ),
    ]);

    // 2. Muat Riwayat dari AI Dashboard
    await _loadAiHistory();
    
    _applyFilters();
  }

  Future<void> _loadAiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(AppConstants.keyChatHistory);
    
    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson);
        final List<String> extensions = ['pdf', 'pptx', 'docx', 'xlsx'];
        int count = 0;

        for (var chat in decoded.reversed) {
          final String question = chat['q'] ?? "Pencarian AI";
          final String answer = chat['a'] ?? "";
          final String ext = extensions[count % extensions.length];
          
          // Tambahkan sebagai kategori Dokumen sesuai permintaan
          _allHistoryList.add(HistoryItem(
            id: 'ai_${count}_${DateTime.now().millisecondsSinceEpoch}',
            title: '${question.toString().replaceAll(' ', '_').split('?')[0]}.$ext',
            timestamp: 'Baru saja',
            category: 'dokumen',
            snippet: answer,
          ));

          // Tambahkan juga ke kategori Tanya untuk history lengkap
          _allHistoryList.add(HistoryItem(
            id: 'qa_${count}_${DateTime.now().millisecondsSinceEpoch}',
            title: question,
            timestamp: 'Baru saja',
            category: 'tanya',
            snippet: answer,
          ));

          count++;
        }
      } catch (e) {
        debugPrint('Error loading AI history in ActivityScreen: $e');
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    if (!mounted) return;
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
    Navigator.pushNamed(
      context,
      '/document-view',
      arguments: {
        'title': item.title,
        'content': item.snippet, // Menggunakan snippet sebagai isi simulasi
        'category': item.category,
      },
    );
  }

  void _handleDownloadItem(HistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mengunduh "${item.title}"...')),
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
                          _buildFilterChip(label: AppStrings.filterBelajar, filterKey: 'belajar'),
                          const SizedBox(width: 8),
                          _buildFilterChip(label: AppStrings.filterTanya, filterKey: 'tanya'),
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
                                onDownload: _handleDownloadItem,
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
