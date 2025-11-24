import 'package:custom_mp_app/app/data/models/notification/notification_model.dart';
import 'package:get/get.dart';

/// Notification Controller
///
/// Manages notification state and actions
class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  // Observable notifications list
  final notifications = <NotificationModel>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Unread count
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _loadExampleNotifications();
  }

  /// Load example/static notifications (no API calls)
  void _loadExampleNotifications() {
    notifications.value = [
      NotificationModel(
        id: '1',
        title: 'Order Shipped',
        message: 'Your order #12345 has been shipped and is on the way!',
        type: 'order',
        isRead: false,
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        imageUrl: 'https://via.placeholder.com/100',
        data: {'order_id': '12345'},
      ),
      NotificationModel(
        id: '2',
        title: 'Flash Sale Alert! 🔥',
        message: 'Get up to 50% off on fresh vegetables today only!',
        type: 'promotion',
        isRead: false,
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
        imageUrl: 'https://via.placeholder.com/100',
      ),
      NotificationModel(
        id: '3',
        title: 'Order Delivered',
        message: 'Your order #12344 has been delivered successfully.',
        type: 'order',
        isRead: true,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        data: {'order_id': '12344'},
      ),
      NotificationModel(
        id: '4',
        title: 'New Products Available',
        message: 'Check out our new organic coconut collection!',
        type: 'product',
        isRead: true,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        imageUrl: 'https://via.placeholder.com/100',
      ),
      NotificationModel(
        id: '5',
        title: 'Payment Successful',
        message: 'Your payment of ₱1,250.00 has been processed.',
        type: 'order',
        isRead: true,
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        data: {'order_id': '12343'},
      ),
      NotificationModel(
        id: '6',
        title: 'Weekend Special 🎉',
        message: 'Enjoy free delivery on orders above ₱500 this weekend!',
        type: 'promotion',
        isRead: true,
        createdAt: DateTime.now().subtract(Duration(days: 4)),
      ),
      NotificationModel(
        id: '7',
        title: 'Account Update',
        message: 'Your profile information has been updated successfully.',
        type: 'system',
        isRead: true,
        createdAt: DateTime.now().subtract(Duration(days: 7)),
      ),
    ];
  }

  /// Mark notification as read (UI only - no API)
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();
    }
  }

  /// Mark all as read (UI only - no API)
  void markAllAsRead() {
    notifications.value = notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
  }

  /// Delete notification (UI only - no API)
  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
  }

  /// Clear all notifications (UI only - no API)
  void clearAll() {
    notifications.clear();
  }

  /// Refresh notifications (placeholder for future API call)
  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Simulate API call
    _loadExampleNotifications();
    isLoading.value = false;
  }
}
