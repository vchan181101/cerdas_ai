import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/data/adapters/history_adapter.dart';
import 'package:cerdas_ai/core/app_constants.dart';
import 'package:cerdas_ai/core/helpers/helpers.dart';
import 'package:cerdas_ai/menu/menu.dart';
import 'package:cerdas_ai/data/models/history_item.dart';
import 'package:cerdas_ai/core/values/strings.dart';
import 'package:cerdas_ai/presentation/widgets/background_wrapper.dart';
import 'package:cerdas_ai/presentation/widgets/bottom_navigation_view_widget.dart';

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
    // 1. Tambahkan Data Simulasi Default Sesuai Desain Gambar 2
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
      HistoryItem(
        id: 'sim_3',
        title: 'Pertanyaan_lama_#3.pdf',
        timestamp: 'Baru saja',
        category: 'dokumen',
        snippet: 'Jawaban lama #3 dari server...',
      ),
      HistoryItem(
        id: 'sim_4',
        title: 'Pertanyaan lama #3',
        timestamp: 'Baru saja',
        category: 'tanya',
        snippet: 'Jawaban lama #3 dari server...',
      ),
      HistoryItem(
        id: 'sim_5',
        title: 'Pertanyaan_lama_#2.pptx',
        timestamp: 'Baru saja',
        category: 'dokumen',
        snippet: 'Jawaban lama #2 dari server...',
      ),
    ]);

    // 2. Muat Riwayat dari AI Dashboard jika ada
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
          
          // Tambahkan sebagai kategori Dokumen
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);

    return Scaffold(
      body: BackgroundWrapper(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    children: [
                      // Judul Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.titleAktivitas,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: headingColor,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Bar Modern
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06),
                            width: 1,
                          ),
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          style: TextStyle(fontSize: 14, color: headingColor),
                          decoration: InputDecoration(
                            hintText: AppStrings.hintSearchRiwayat,
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: isDark ? Colors.white54 : const Color(0xFF64748B),
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Baris Filter Chips (Semua, Dokumen, Belajar, Tanya)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(label: AppStrings.filterSemua, filterKey: 'semua'),
                            const SizedBox(width: 10),
                            _buildFilterChip(label: AppStrings.filterDokumen, filterKey: 'dokumen'),
                            const SizedBox(width: 10),
                            _buildFilterChip(label: AppStrings.filterBelajar, filterKey: 'belajar'),
                            const SizedBox(width: 10),
                            _buildFilterChip(label: AppStrings.filterTanya, filterKey: 'tanya'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Daftar List Aktivitas
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const activeColor = Color(0xFF7C3AED); // Ungu bergradasi/glow sesuai Gambar 2

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = filterKey;
          _applyFilters();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isActive
                ? activeColor
                : (isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08)),
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.45),
                    blurRadius: 14,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ]
              : (isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ]),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive
                ? Colors.white
                : (isDark ? Colors.white : const Color(0xFF1E293B)),
          ),
        ),
      ),
    );
  }
}
