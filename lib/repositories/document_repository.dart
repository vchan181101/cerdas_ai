import '../core/core.dart';
import '../models/history_item.dart';

/// Interface untuk manajemen riwayat dokumen dan aktivitas AI pengguna.
abstract class IDocumentRepository {
  /// Mendapatkan semua dokumen yang tidak berada di tempat sampah.
  FutureEither<List<HistoryItem>> getActiveDocuments();

  /// Mendapatkan semua dokumen yang telah dihapus (di tempat sampah).
  FutureEither<List<HistoryItem>> getTrashDocuments();

  /// Mencari dokumen berdasarkan judul atau isi ringkasan.
  FutureEither<List<HistoryItem>> searchDocuments(String query);

  /// Menambahkan riwayat aktivitas baru ke daftar teratas.
  FutureEither<void> addItem(HistoryItem item);

  /// Mengubah status favorit sebuah dokumen.
  FutureEither<void> toggleFavorite(String id);

  /// Memindahkan dokumen ke tempat sampah (Soft Delete).
  FutureEither<void> moveToTrash(String id);

  /// Mengembalikan dokumen dari tempat sampah.
  FutureEither<void> restoreFromTrash(String id);

  /// Menghapus dokumen secara permanen dari penyimpanan.
  FutureEither<void> deletePermanently(String id);
}

class DocumentRepository implements IDocumentRepository {
  static final DocumentRepository _instance = DocumentRepository._internal();
  factory DocumentRepository() => _instance;

  DocumentRepository._internal() {
    _initInitialData();
  }

  static DocumentRepository get instance => _instance;

  final List<HistoryItem> _allItems = [];

  void _initInitialData() {
    if (_allItems.isNotEmpty) return;
    
    _allItems.addAll([
      HistoryItem(
        id: '1',
        category: 'PDF',
        title: 'Laporan_Keuangan_Q3.pdf',
        snippet: 'Ringkas tabel pengeluaran operasional...',
        timestamp: 'Hari ini, 14:20',
        isFavorite: true,
      ),
      HistoryItem(
        id: '2',
        category: 'Foto',
        title: 'Foto_Resep_Makanan.jpg',
        snippet: 'Tuliskan langkah resep dari foto bahan ini..',
        timestamp: 'Kemarin, 09:15',
      ),
      HistoryItem(
        id: '3',
        category: 'Teks',
        title: 'Kueri Teks AI',
        snippet: 'Apa bedanya machine learning dan AI?',
        timestamp: '24 Okt 2026',
      ),
      HistoryItem(
        id: '4',
        category: 'PPT',
        title: 'Presentasi_Proyek.pptx',
        snippet: 'Koreksi struktur poin di slide kedua...',
        timestamp: '22 Okt 2026',
      ),
    ]);
  }

  @override
  FutureEither<List<HistoryItem>> getActiveDocuments() async {
    try {
      final docs = _allItems.where((item) => !item.isInTrash).toList();
      return Functional.success(List.unmodifiable(docs));
    } catch (e) {
      LoggerUtil.error('Gagal mengambil dokumen aktif', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<HistoryItem>> getTrashDocuments() async {
    try {
      final docs = _allItems.where((item) => item.isInTrash).toList();
      return Functional.success(List.unmodifiable(docs));
    } catch (e) {
      LoggerUtil.error('Gagal mengambil dokumen sampah', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<HistoryItem>> searchDocuments(String query) async {
    try {
      if (query.isEmpty) return await getActiveDocuments();
      
      final results = _allItems.where((item) {
        final matchesQuery = item.title.toLowerCase().contains(query.toLowerCase()) || 
                             item.snippet.toLowerCase().contains(query.toLowerCase());
        return !item.isInTrash && matchesQuery;
      }).toList();
      
      return Functional.success(results);
    } catch (e) {
      LoggerUtil.error('Gagal mencari dokumen: $query', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> addItem(HistoryItem item) async {
    try {
      _allItems.insert(0, item);
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Gagal menambah dokumen', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> toggleFavorite(String id) async {
    try {
      final index = _allItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _allItems[index] = _allItems[index].copyWith(
          isFavorite: !_allItems[index].isFavorite,
        );
      }
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Gagal mengubah status favorit', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> moveToTrash(String id) async {
    try {
      final index = _allItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _allItems[index] = _allItems[index].copyWith(isInTrash: true);
      }
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Gagal memindahkan ke sampah', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> restoreFromTrash(String id) async {
    try {
      final index = _allItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _allItems[index] = _allItems[index].copyWith(isInTrash: false);
      }
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Gagal mengembalikan dari sampah', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deletePermanently(String id) async {
    try {
      _allItems.removeWhere((item) => item.id == id);
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Gagal menghapus permanen', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }
}
