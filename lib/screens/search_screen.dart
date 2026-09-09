import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../values/strings.dart';

/// Data Model untuk Hasil Pencarian
class SearchResultItem {
  final String title;
  final String type;
  final IconData iconData;
  final String targetRoute;

  SearchResultItem({
    required this.title,
    required this.type,
    required this.iconData,
    required this.targetRoute,
  });
}

/// Model Simulasi Riwayat & Dokumen Dinamis
class DynamicContentItem {
  final String title;
  final String snippet;
  final String category; // 'PDF', 'PPT', 'WORD', 'Foto', 'Teks'

  DynamicContentItem({
    required this.title,
    required this.snippet,
    required this.category,
  });
}

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  late String _searchResultPrefixText;
  List<SearchResultItem> _searchResults = [];

  // Master Dataset Simulasi
  final List<DynamicContentItem> _mockDynamicRepository = [
    DynamicContentItem(
      title: 'Ringkasan Laporan Keuangan Q3.pdf',
      snippet: 'Laporan keuangan perusahaan',
      category: 'PDF',
    ),
    DynamicContentItem(
      title: 'Slide Presentasi Proyek Imperial World Kingdom.pptx',
      snippet: 'Desain arsitektur dan anggaran',
      category: 'PPT',
    ),
    DynamicContentItem(
      title: 'Panduan Penulisan Skripsi Rekayasa Kebakaran.docx',
      snippet: 'Format penulisan bab 1-3',
      category: 'WORD',
    ),
    DynamicContentItem(
      title: 'Foto Proklamasi',
      snippet: 'Dokumentasi foto kegiatan',
      category: 'Foto',
    ),
    DynamicContentItem(
      title: 'Bagaimana cara kerja Support Vector Machine?',
      snippet: 'Pertanyaan seputar machine learning',
      category: 'Teks',
    ),
  ];

  // Dataset rekomendasi untuk SearchDelegate Interaktif
  final List<String> _delegateSuggestions = [
    'Cara membuat akun Cerdas AI',
    'Panduan ringkas dokumen PDF',
    'Ganti kata sandi & keamanan',
    'Integrasi Google & Apple ID',
    'Pemeriksaan riwayat aktivitas',
  ];

  @override
  void initState() {
    super.initState();
    _searchResultPrefixText = AppStrings.hintStartSearch;
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 1. Logika Eksekusi Pencarian
  void _performSearch(String query) {
    final queryLower = query.toLowerCase().trim();

    if (queryLower.isEmpty) {
      setState(() {
        _searchResultPrefixText = AppStrings.hintStartSearch;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _searchResultPrefixText = '${AppStrings.searchResultPrefix} "$query"';
    });

    List<SearchResultItem> results = [];

    // A. Cari di Halaman Statis / Menu Utama
    if ('dashboard beranda home utama'.contains(queryLower)) {
      results.add(SearchResultItem(
        title: 'Dashboard / Beranda',
        type: 'Halaman Utama',
        iconData: Icons.dashboard,
        targetRoute: '/dashboard',
      ));
    }
    if ('aktivitas riwayat history'.contains(queryLower)) {
      results.add(SearchResultItem(
        title: 'Aktivitas / Riwayat',
        type: 'Daftar Pertanyaan & Jawaban',
        iconData: Icons.history,
        targetRoute: '/aktivitas',
      ));
    }
    if ('informasi dokumen file berkas global info'.contains(queryLower)) {
      results.add(SearchResultItem(
        title: 'Informasi / Dokumen',
        type: 'Kelola Berkas & Dokumen',
        iconData: Icons.explore,
        targetRoute: '/informasi',
      ));
    }
    if ('pengaturan setting tema bahasa profil account akun'.contains(queryLower)) {
      results.add(SearchResultItem(
        title: 'Pengaturan / Settings',
        type: 'Ubah Tema, Bahasa, & Profil',
        iconData: Icons.settings,
        targetRoute: '/setting',
      ));
    }

    // B. Cari di Konten Dinamis
    for (var item in _mockDynamicRepository) {
      if (item.title.toLowerCase().contains(queryLower) ||
          item.snippet.toLowerCase().contains(queryLower) ||
          item.category.toLowerCase().contains(queryLower)) {
        String targetRoute = '/dashboard';
        if (item.category == 'PDF' || item.category == 'PPT' || item.category == 'WORD') {
          targetRoute = '/informasi';
        } else if (item.category == 'Teks' || item.category == 'Foto') {
          targetRoute = '/aktivitas';
        }

        results.add(SearchResultItem(
          title: item.title,
          type: 'Hasil dari ${item.category}',
          iconData: _getIconForCategory(item.category),
          targetRoute: targetRoute,
        ));
      }
    }

    setState(() {
      _searchResults = results;
    });

    if (results.isEmpty && mounted) {
      context.showSnackBar('Tidak ada hasil ditemukan untuk: $query');
    }
  }

  // 2. Fungsi Membuka SearchDelegate Interaktif
  void _openSearchDelegate() async {
    final result = await showSearch<String?>(
      context: context,
      delegate: CustomSearchDelegate(searchDataList: _delegateSuggestions),
    );

    if (result != null && result.isNotEmpty) {
      _searchController.text = result;
      _performSearch(result);
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'WORD':
        return Icons.description;
      case 'PPT':
        return Icons.slideshow;
      case 'FOTO':
        return Icons.camera_alt;
      default:
        return Icons.search;
    }
  }

  @override
  Widget build(BuildContext context) {
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);

    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ScreenColorHelper.getSurfaceColor(context),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: headingColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(fontSize: 16, color: headingColor),
          decoration: InputDecoration(
            hintText: AppStrings.hintPencarian,
            hintStyle: TextStyle(color: bodyColor.withValues(alpha: 0.5)),
            border: InputBorder.none,
          ),
          onChanged: (value) => _performSearch(value),
          onSubmitted: (value) => _performSearch(value),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: bodyColor.withValues(alpha: 0.5)),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
          IconButton(
            icon: Icon(Icons.saved_search, color: primaryColor),
            tooltip: 'Pencarian Interaktif',
            onPressed: _openSearchDelegate,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status Hasil Pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _searchResultPrefixText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: headingColor,
              ),
            ),
          ),

          // ListView Hasil Pencarian
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_outlined, size: 64, color: bodyColor.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text(
                    'Ketik kata kunci untuk memulai pencarian',
                    style: TextStyle(color: bodyColor, fontSize: 14),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final item = _searchResults[index];
                return _buildSearchResultTile(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultTile(SearchResultItem item) {
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      color: ScreenColorHelper.getSurfaceColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.iconData, color: primaryColor),
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: headingColor,
          ),
        ),
        subtitle: Text(
          item.type,
          style: TextStyle(fontSize: 12, color: bodyColor),
        ),
        trailing: Icon(Icons.chevron_right, color: bodyColor.withValues(alpha: 0.5)),
        onTap: () {
          Navigator.pushNamed(context, item.targetRoute);
        },
      ),
    );
  }
}
