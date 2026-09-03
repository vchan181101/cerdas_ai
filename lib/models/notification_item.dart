class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String type; // 'UPDATE', 'AI_SUCCESS', 'DOC_SUCCESS', 'INFO'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    String? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
