import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/notifications/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

/// Notifications App Bar
///
/// SliverAppBar with actions for notifications page
class NotificationsAppBar extends StatelessWidget {
  const NotificationsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return SliverAppBar(
      backgroundColor: AppColors.brand,
      elevation: 0,
      floating: true,
      pinned: true,
      leading: IconButton(
        icon: const HeroIcon(HeroIcons.arrowLeft, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
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
          if (controller.unreadCount.value > 0) {
            return TextButton(
              onPressed: () => controller.markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        // Menu button
        PopupMenuButton<String>(
          icon: const HeroIcon(HeroIcons.ellipsisVertical, color: Colors.white),
          onSelected: (value) => _handleMenuAction(value, controller),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear_read',
              child: Row(
                children: [
                  Icon(Icons.delete_sweep, size: 18, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Clear Read'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Refresh'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Handle menu actions
  void _handleMenuAction(String value, NotificationController controller) async {
    switch (value) {
      case 'clear_read':
        final confirmed = await AppModal.confirm(
          title: 'Clear Read Notifications?',
          message: 'This will permanently delete all read notifications.',
          confirmText: 'Clear',
          cancelText: 'Cancel',
        );

        if (confirmed == true) {
          controller.clearReadNotifications();
        }
        break;

      case 'refresh':
        controller.refresh();
        break;
    }
  }
}
