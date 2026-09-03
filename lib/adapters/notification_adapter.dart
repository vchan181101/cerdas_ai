import 'package:flutter/material.dart';

import '../models/notification_item.dart';
import '../values/colors.dart';

class NotificationAdapter extends StatelessWidget {
  final List<NotificationItem> notificationList;
  final ValueChanged<NotificationItem> onItemClick;

  const NotificationAdapter({
    super.key,
    required this.notificationList,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        final item = notificationList[index];
        return NotificationItemTile(
          item: item,
          onTap: () => onItemClick(item),
        );
      },
    );
  }
}

/// Widget Item Tunggal (Konversi dari ViewHolder & item_notification.xml)
class NotificationItemTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const NotificationItemTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  // Dynamic Icon & Color Styling berdasarkan tipe
  Map<String, dynamic> _getStyleByType(String type) {
    switch (type.toUpperCase()) {
      case 'UPDATE':
        return {
          'color': const Color(0xFF6366F1), // Indigo/Purple
          'icon': Icons.notifications_active,
        };
      case 'AI_SUCCESS':
        return {
          'color': const Color(0xFF10B981), // Emerald Green
          'icon': Icons.check_circle,
        };
      case 'DOC_SUCCESS':
        return {
          'color': const Color(0xFF10B981), // Emerald Green
          'icon': Icons.description,
        };
      default: // INFO atau Lainnya
        return {
          'color': const Color(0xFF3B82F6), // Blue
          'icon': Icons.info,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getStyleByType(item.type);
    final Color iconColor = style['color'];
    final IconData iconData = style['icon'];

    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      elevation: 1,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // Content Detail (Title, Description, & Time)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
