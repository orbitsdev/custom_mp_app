/// Notification Model
///
/// Represents a notification item
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'order', 'promotion', 'system', 'product'
  final bool isRead;
  final DateTime createdAt;
  final String? imageUrl;
  final Map<String, dynamic>? data; // Additional data (order_id, product_id, etc.)

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.imageUrl,
    this.data,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'system',
      isRead: map['is_read'] ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      imageUrl: map['image_url'],
      data: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'image_url': imageUrl,
      'data': data,
    };
  }

  /// Copy with method for updating notification
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
    );
  }
}
