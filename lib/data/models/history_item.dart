class HistoryItem {
  final String id;
  final String category; // "Dokumen", "Foto", "Teks", "PPT", "PDF", dll.
  String title;
  final String snippet;
  final String timestamp;
  bool isFavorite;
  bool isInTrash;
  final String? filePath;
  final String? ext;

  HistoryItem({
    required this.id,
    required this.category,
    required this.title,
    required this.snippet,
    required this.timestamp,
    this.isFavorite = false,
    this.isInTrash = false,
    this.filePath,
    this.ext,
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
    String? filePath,
    String? ext,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
      isInTrash: isInTrash ?? this.isInTrash,
      filePath: filePath ?? this.filePath,
      ext: ext ?? this.ext,
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
      filePath: json['filePath'] as String?,
      ext: json['ext'] as String?,
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
      if (filePath != null) 'filePath': filePath,
      if (ext != null) 'ext': ext,
    };
  }
}