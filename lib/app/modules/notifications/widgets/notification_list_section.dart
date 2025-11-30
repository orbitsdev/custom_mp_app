import 'package:custom_mp_app/app/modules/notifications/controllers/notification_controller.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notification_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

/// Notification List Section
///
/// Masonry grid of notification cards with pagination
class NotificationListSection extends StatelessWidget {
  const NotificationListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Obx(() {
      final notifications = controller.notifications;

      if (notifications.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: 1, // Single column for notifications
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childCount: notifications.length,
          itemBuilder: (context, index) {
            // Load more when reaching near the end
            if (index == notifications.length - 3) {
              controller.loadMore();
            }

            final notification = notifications[index];
            return NotificationCardWidget(
              notification: notification,
              onTap: () => _handleNotificationTap(
                controller,
                notification.id,
                notification.isRead,
                notification.type,
                notification.data,
              ),
              onDismissed: () => controller.deleteNotification(
                notification.id,
              ),
            );
          },
        ),
      );
    });
  }

  /// Handle notification tap
  void _handleNotificationTap(
    NotificationController controller,
    String notificationId,
    bool isRead,
    String type,
    Map<String, dynamic>? data,
  ) {
    // Mark as read if unread
    if (!isRead) {
      controller.markAsRead(notificationId);
    }

    // Navigate based on notification type and data
    if (data != null) {
      final screen = data['screen'] as String?;

      switch (type) {
        case 'order_status_update':
          final orderId = data['order_id'];
          if (orderId != null && screen == 'order_details') {
            // TODO: Navigate to order details
            // Get.toNamed(Routes.orderDetailPage, arguments: orderId);
          }
          break;

        case 'product':
          final productId = data['product_id'];
          if (productId != null && screen == 'product_details') {
            // TODO: Navigate to product details
            // Get.toNamed(Routes.productDetailsPage, arguments: productId);
          }
          break;

        case 'promo':
          // TODO: Handle promo navigation
          break;

        default:
          // Generic screen navigation
          if (screen != null) {
            // TODO: Navigate to screen
          }
          break;
      }
    }
  }
}
