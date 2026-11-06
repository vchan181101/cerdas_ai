import 'package:cerdas_ai/core/core.dart';
import 'package:cerdas_ai/data/models/history_item.dart';

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
  static DocumentRepository getInstance() => _instance;

  final List<HistoryItem> _allItems = [];

  List<HistoryItem> getAllItems() => List<HistoryItem>.from(_allItems);

  void setFavorite(String id, bool isFavorite) {
    final index = _allItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _allItems[index] = _allItems[index].copyWith(isFavorite: isFavorite);
    }
  }

  void _initInitialData() {
    if (_allItems.isNotEmpty) return;
    
    final now = DateTime.now();
    _allItems.addAll([
      HistoryItem(
        id: '1',
        category: 'Foto',
        title: 'Foto_Catatan_Matematika.jpg',
        snippet: 'Rumus trigonometri dan kalkulus turunan...',
        timestamp: 'Hari ini, 10:15',
        isFavorite: false,
        imageUri: 'asset/ic_logo_aicerdas.png',
        filePath: 'asset/ic_logo_aicerdas.png',
        timestampLong: now.millisecondsSinceEpoch,
        fileSize: '0,90 MB',
        fileFormat: 'JPG',
      ),
      HistoryItem(
        id: '2',
        category: 'Foto',
        title: 'Foto_Resep_Makanan.jpg',
        snippet: 'Tuliskan langkah resep dari foto bahan ini..',
        timestamp: 'Hari ini, 09:15',
        isFavorite: false,
        imageUri: 'asset/ic_logo_circle_clean.png',
        filePath: 'asset/ic_logo_circle_clean.png',
        timestampLong: now.millisecondsSinceEpoch,
        fileSize: '1,45 MB',
        fileFormat: 'PNG',
      ),
      HistoryItem(
        id: '3',
        category: 'Foto',
        title: 'Diagram_Fisika_Optik.png',
        snippet: 'Diagram pembiasan lensa cekung dan cembung...',
        timestamp: 'Hari ini, 08:30',
        isFavorite: true,
        imageUri: 'asset/ic_logo_aicerdas.jpg',
        filePath: 'asset/ic_logo_aicerdas.jpg',
        timestampLong: now.millisecondsSinceEpoch,
        fileSize: '2,10 MB',
        fileFormat: 'PNG',
      ),
      HistoryItem(
        id: '4',
        category: 'PDF',
        title: 'Laporan_Keuangan_Q3.pdf',
        snippet: 'Ringkas tabel pengeluaran operasional...',
        timestamp: 'Hari ini, 14:20',
        isFavorite: true,
        timestampLong: now.millisecondsSinceEpoch,
        fileSize: '3,20 MB',
        fileFormat: 'PDF',
      ),
      HistoryItem(
        id: '5',
        category: 'PPT',
        title: 'Presentasi_Proyek.pptx',
        snippet: 'Koreksi struktur poin di slide kedua...',
        timestamp: '22 Okt 2026',
        timestampLong: now.subtract(const Duration(days: 15)).millisecondsSinceEpoch,
        fileSize: '5,60 MB',
        fileFormat: 'PPTX',
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
