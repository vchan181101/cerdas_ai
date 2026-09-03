class HistoryItem {
  final String id;
  final String category; // "Dokumen", "Foto", "Teks", "PPT", "PDF", dll.
  String title;
  final String snippet;
  final String timestamp;
  bool isFavorite;
  bool isInTrash;

  HistoryItem({
    required this.id,
    required this.category,
    required this.title,
    required this.snippet,
    required this.timestamp,
    this.isFavorite = false,
    this.isInTrash = false,
  });

  // Method copyWith untuk immutability / update state dengan aman di Flutter
  HistoryItem copyWith({
    String? id,
    String? category,
    String? title,
    String? snippet,
    String? timestamp,
    bool? isFavorite,
    bool? isInTrash,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
      isInTrash: isInTrash ?? this.isInTrash,
    );
  }

  // Konversi dari Map / JSON (untuk SharedPreferences / API)
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      snippet: json['snippet'] as String,
      timestamp: json['timestamp'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isInTrash: json['isInTrash'] as bool? ?? false,
    );
  }

  // Konversi ke Map / JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'snippet': snippet,
      'timestamp': timestamp,
      'isFavorite': isFavorite,
      'isInTrash': isInTrash,
    };
  }
}