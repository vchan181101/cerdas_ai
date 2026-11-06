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
  final String? imageUri;
  final int? timestampLong;
  final String? fileSize;
  final String? fileFormat;

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
    this.imageUri,
    this.timestampLong,
    this.fileSize,
    this.fileFormat,
  });

  // Getter & Helper kompatibel dengan Java
  String getId() => id;
  String getTitle() => title;
  String getSnippet() => snippet;
  String? getImageUri() => imageUri ?? filePath;
  int getTimestampLong() => timestampLong ?? DateTime.now().millisecondsSinceEpoch;
  String getFileSize() => fileSize ?? '0,90 MB';
  String getFileFormat() => fileFormat ?? (ext != null ? ext!.replaceAll('.', '').toUpperCase() : 'JPG');

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
    String? imageUri,
    int? timestampLong,
    String? fileSize,
    String? fileFormat,
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
      imageUri: imageUri ?? this.imageUri,
      timestampLong: timestampLong ?? this.timestampLong,
      fileSize: fileSize ?? this.fileSize,
      fileFormat: fileFormat ?? this.fileFormat,
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
      imageUri: json['imageUri'] as String?,
      timestampLong: json['timestampLong'] as int?,
      fileSize: json['fileSize'] as String?,
      fileFormat: json['fileFormat'] as String?,
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
      if (imageUri != null) 'imageUri': imageUri,
      if (timestampLong != null) 'timestampLong': timestampLong,
      if (fileSize != null) 'fileSize': fileSize,
      if (fileFormat != null) 'fileFormat': fileFormat,
    };
  }
}
