import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/sliver_v_gap.dart';
import 'package:custom_mp_app/app/modules/notifications/controllers/notification_controller.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notification_empty_state_widget.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notification_list_section.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notification_loading_more.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notification_skeleton_sliver.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notifications_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Notifications Page
///
/// Displays all user notifications with API integration, pagination, and pull-to-refresh
/// Uses CustomScrollView with slivers for advanced scroll behavior
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final isRefreshing = controller.isRefreshing.value;
        final notifications = controller.notifications;
        final isEmpty = notifications.isEmpty;

        // Show skeleton during initial load or when refreshing
        final showSkeleton = (isLoading && isEmpty) || isRefreshing;

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppColors.brand,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App Bar
              const NotificationsAppBar(),

              // Loading skeleton (initial load or refreshing)
              if (showSkeleton) const NotificationSkeletonSliver(),

              // Empty state (only when not loading/refreshing)
              if (!showSkeleton && isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: NotificationEmptyStateWidget(),
                ),

              // Notifications list (hide during refresh)
              if (!showSkeleton && !isEmpty) const NotificationListSection(),

              // Loading more indicator
               const NotificationLoadingMore(),

              // Bottom spacing
              if (!showSkeleton && !isEmpty) SliverVGap(24),
            ],
          ),
        );
      }),
    );
  }
}
