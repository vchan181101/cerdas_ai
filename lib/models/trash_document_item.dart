class TrashDocumentItem {
  final String id;
  final String title;
  final String date;
  final String category; // 'PDF', 'PPT', 'EXCEL', 'GAMBAR', 'WORD', dll.
  bool isSelected;

  TrashDocumentItem({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    this.isSelected = false,
  });

  TrashDocumentItem copyWith({
    String? id,
    String? title,
    String? date,
    String? category,
    bool? isSelected,
  }) {
    return TrashDocumentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      category: category ?? this.category,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
