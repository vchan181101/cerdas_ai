import 'package:flutter/material.dart';
import '../../adapters/manage_doc_adapter.dart';
import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../models/history_item.dart';
import '../../repositories/repositories.dart';
import '../../values/values.dart';

class ExampleDocumentListScreen extends StatefulWidget {
  const ExampleDocumentListScreen({super.key});

  @override
  State<ExampleDocumentListScreen> createState() => _ExampleDocumentListScreenState();
}

class _ExampleDocumentListScreenState extends State<ExampleDocumentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  
  List<HistoryItem> _activeDocs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshDocs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  // 1. Memuat ulang data dari Singleton Repository
  Future<void> _refreshDocs() async {
    setState(() => _isLoading = true);
    
    final query = _searchController.text.trim();
    final result = query.isEmpty 
        ? await DocumentRepository.instance.getActiveDocuments()
        : await DocumentRepository.instance.searchDocuments(query);
    
    if (!mounted) return;
    
    result.fold(
      (failure) => context.showSnackBar(failure.message),
      (docs) => setState(() => _activeDocs = docs),
    );
    
    setState(() => _isLoading = false);
  }

  // 2. Logika Pencarian dengan Debouncer
  void _onSearchChanged(String query) {
    _debouncer.run(() => _refreshDocs());
  }

  // 3. Menambah Dokumen Baru (Simulasi)
  Future<void> _addNewDocument() async {
    final newItem = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: ['PDF', 'PPT', 'WORD', 'IMAGE'][DateTime.now().second % 4],
      title: 'Dokumen_Demo_\${DateTime.now().minute}\${DateTime.now().second}.pdf',
      snippet: 'Hasil ekstraksi data simulasi...',
      timestamp: DateTime.now().toFormattedStringWithTime,
    );

    final result = await DocumentRepository.instance.addItem(newItem);
    result.fold(
      (failure) => context.showSnackBar(failure.message),
      (_) {
        _refreshDocs();
        context.showSnackBar('Dokumen baru ditambahkan!');
      },
    );
  }

  // 4. Memindahkan ke Sampah
  /* Future<void> _deleteDoc(String id) async {
    final result = await DocumentRepository.instance.moveToTrash(id);
    result.fold(
      (failure) => context.showSnackBar(failure.message),
      (_) {
        _refreshDocs();
        context.showSnackBar('Dokumen dipindahkan ke sampah');
      },
    );
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: AppBar(
        title: const Text('Simulasi Data Dokumen'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: _refreshDocs,
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar Section
          _buildSearchHeader(),

          // List Section dengan RefreshIndicator
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDocs,
              color: AppColors.indigoPrimary,
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _activeDocs.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _activeDocs.length,
                        itemBuilder: (context, index) {
                          final item = _activeDocs[index];
                          // Menggunakan ManageDocItemTile dari adapters untuk konsistensi
                          return ManageDocItemTile(
                            item: item,
                            isSelectionMode: false,
                            isSelected: false,
                            onTap: () => context.showSnackBar('Detail: \${item.title}'),
                            onCheckboxChanged: (_) {},
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDocument,
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Dokumen',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: AppColors.indigoPrimary,
      child: Container(
        decoration: ScreenStyleHelper.getSearchBarDecoration(context),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.iconTint, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Cari nama dokumen...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _refreshDocs();
                },
                child: const Icon(Icons.cancel, color: AppColors.iconTint, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView( // Agar RefreshIndicator tetap bisa ditarik walau kosong
      children: [
        SizedBox(height: context.screenHeight * 0.25),
        const Icon(Icons.folder_open_rounded, size: 80, color: AppColors.iconTint),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Tidak ada dokumen aktif ditemukan',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
