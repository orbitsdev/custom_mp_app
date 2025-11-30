/// Notification Model
///
/// Represents a notification item from the API
/// Based on /api/notifications endpoint response
class NotificationModel {
  final String id; // UUID
  final String type; // 'order_status_update', 'product', 'promo', 'welcome', 'general'
  final String title;
  final String body; // API uses 'body' not 'message'
  final Map<String, dynamic>? data; // Additional data (order_id, product_id, screen, etc.)
  final String? readAt; // ISO 8601 timestamp when read (null if unread)
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.readAt,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    // Extract data
    final dataMap = map['data'] != null ? Map<String, dynamic>.from(map['data']) : null;

    // API often returns title and body as null
    // Actual message is in data.message or data.description
    String title = map['title'] ?? '';
    String body = map['body'] ?? '';

    // If title/body are empty, extract from data
    if ((title.isEmpty || body.isEmpty) && dataMap != null) {
      final message = dataMap['message'] as String?;
      final description = dataMap['description'] as String?;

      if (title.isEmpty) {
        // Generate title from type
        final type = map['type'] as String? ?? 'general';
        title = _generateTitleFromType(type);
      }

      if (body.isEmpty) {
        body = message ?? description ?? '';
      }
    }

    return NotificationModel(
      id: map['id']?.toString() ?? '',
      type: map['type'] ?? 'general',
      title: title,
      body: body,
      data: dataMap,
      readAt: map['read_at'],
      isRead: map['is_read'] ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  /// Generate user-friendly title from notification type
  static String _generateTitleFromType(String type) {
    switch (type) {
      case 'order_status_update':
        return 'Order Update';
      case 'product':
        return 'Product Update';
      case 'promo':
        return 'Special Offer';
      case 'welcome':
        return 'Welcome!';
      case 'general':
      default:
        return 'Notification';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'read_at': readAt,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copy with method for updating notification
  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? readAt,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
