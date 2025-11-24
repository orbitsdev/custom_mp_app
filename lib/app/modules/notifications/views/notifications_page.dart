import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/notification/notification_model.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/notifications/controllers/notification_controller.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notification_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Notifications Page
///
/// Shows all user notifications with static/example data
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        backgroundColor: AppColors.brand,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(HeroIcons.arrowLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          // Mark all as read button
          Obx(() {
            if (controller.unreadCount > 0) {
              return TextButton(
                onPressed: () => controller.markAllAsRead(),
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),

          // Clear all button
          PopupMenuButton<String>(
            icon: HeroIcon(HeroIcons.ellipsisVertical, color: Colors.white),
            onSelected: (value) async {
              if (value == 'clear') {
                final confirmed = await AppModal.confirm(
                  title: 'Clear All Notifications?',
                  message:
                      'This will permanently delete all your notifications.',
                  confirmText: 'Clear',
                  cancelText: 'Cancel',
                );

                if (confirmed == true) {
                  controller.clearAll();
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    Gap(8),
                    Text('Clear All'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return NotificationLoadingCard();
        }

        // Empty state
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        // Notifications list
        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppColors.brand,
          child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => Gap(12),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationCard(notification, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationCard(
      NotificationModel notification, NotificationController controller) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        controller.deleteNotification(notification.id);
      },
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
          // TODO: Navigate to relevant page based on notification.type and notification.data
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : AppColors.brandLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? Colors.grey[200]!
                  : AppColors.brand.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon/image
              _buildNotificationIcon(notification),

              Gap(12),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Gap(4),

                    // Message
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Gap(6),

                    // Time ago
                    Text(
                      timeago.format(notification.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Container(
                  margin: EdgeInsets.only(left: 8),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.brand,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationModel notification) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'order':
        iconData = Icons.shopping_bag;
        iconColor = AppColors.blue;
        break;
      case 'promotion':
        iconData = Icons.local_offer;
        iconColor = AppColors.orange;
        break;
      case 'product':
        iconData = Icons.inventory_2;
        iconColor = AppColors.green;
        break;
      case 'system':
        iconData = Icons.settings;
        iconColor = Colors.grey[600]!;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppColors.brand;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.grey[300],
            ),
            Gap(24),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            Gap(8),
            Text(
              'When you get notifications,\\nthey\'ll show up here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
