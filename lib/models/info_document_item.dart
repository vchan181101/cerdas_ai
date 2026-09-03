class InfoDocumentItem {
  final String id;
  final String title;
  final String date;
  final String category; // 'PDF', 'PPT', 'GAMBAR', 'WORD', 'AUDIO', 'VIDEO'
  bool isFavorite;

  InfoDocumentItem({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    this.isFavorite = false,
  });
}
