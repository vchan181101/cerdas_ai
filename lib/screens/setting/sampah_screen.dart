import 'package:flutter/material.dart';

import '../../adapters/trash_adapter.dart';
import '../../models/trash_document_item.dart';
import '../../values/colors.dart';

class SampahScreen extends StatefulWidget {
  const SampahScreen({super.key});

  @override
  State<SampahScreen> createState() => _SampahScreenState();
}

class _SampahScreenState extends State<SampahScreen> {
  // Repository Data Sampah
  final List<TrashDocumentItem> _masterTrashDocs = [
    TrashDocumentItem(
      id: '1',
      title: 'Draft Proposal Usulan Kegiatan.docx',
      date: '15 Agu 2026',
      category: 'WORD',
    ),
    TrashDocumentItem(
      id: '2',
      title: 'Foto Tangkapan Layar Error.png',
      date: '12 Agu 2026',
      category: 'GAMBAR',
    ),
    TrashDocumentItem(
      id: '3',
      title: 'Laporan Keuangan Bekas Q2.pdf',
      date: '10 Agu 2026',
      category: 'PDF',
    ),
  ];

  List<TrashDocumentItem> _trashDocs = [];
  bool _isSelectionMode = false;
  String _currentMode = ''; // 'restore' atau 'delete'

  @override
  void initState() {
    super.initState();
    _refreshTrashData();
  }

  void _refreshTrashData() {
    setState(() {
      _isSelectionMode = false;
      _currentMode = '';
      _trashDocs = List.from(_masterTrashDocs);
      for (var doc in _trashDocs) {
        doc.isSelected = false;
      }
    });
  }

  void _enableRestoreMode() {
    if (_trashDocs.isEmpty) return;
    setState(() {
      _currentMode = 'restore';
      _isSelectionMode = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pilih file yang ingin dipulihkan')),
    );
  }

  void _enableDeleteMode() {
    if (_trashDocs.isEmpty) return;
    setState(() {
      _currentMode = 'delete';
      _isSelectionMode = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pilih file yang ingin dihapus selamanya')),
    );
  }

  void _cancelSelection() {
    setState(() {
      _isSelectionMode = false;
      _currentMode = '';
      for (var doc in _trashDocs) {
        doc.isSelected = false;
      }
    });
  }

  void _executeAction() {
    final selectedItems = _trashDocs.where((doc) => doc.isSelected).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada file dipilih')),
      );
      return;
    }

    setState(() {
      final List<TrashDocumentItem> itemsToRemove = [];
      for (var item in _trashDocs) {
        if (item.isSelected) itemsToRemove.add(item);
      }
      _masterTrashDocs.removeWhere((doc) => itemsToRemove.contains(doc));
      _refreshTrashData();
    });

    final actionText = _currentMode == 'restore' ? 'dipulihkan' : 'dihapus selamanya';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Berhasil $actionText')),
    );
  }

  void _toggleSelection(TrashDocumentItem item) {
    setState(() {
      item.isSelected = !item.isSelected;
    });
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
                        'Sampah',
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
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _enableRestoreMode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: const Center(
                          child: Text(
                            'Pulihkan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 24, color: const Color(0xFFF1F5F9)),
                  Expanded(
                    child: InkWell(
                      onTap: _enableDeleteMode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: const Center(
                          child: Text(
                            'Hapus Selamanya',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _trashDocs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.delete_outline, size: 48, color: Color(0xFF94A3B8)),
                          SizedBox(height: 12),
                          Text(
                            'Kotak sampah kosong',
                            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: TrashAdapter(
                        trashList: _trashDocs,
                        isSelectionMode: _isSelectionMode,
                        activeCheckboxColor: _currentMode == 'restore'
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFEF4444),
                        onItemClick: (_) {},
                        onItemToggleSelect: _toggleSelection,
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
                        onPressed: _cancelSelection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFF64748B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Tidak'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _executeAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentMode == 'restore'
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Ya'),
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
