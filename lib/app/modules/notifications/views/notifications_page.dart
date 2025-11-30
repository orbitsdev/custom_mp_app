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
        final showSkeleton = (isLoading && isEmpty) || isRefreshing;
        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppColors.brand,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
            
              const NotificationsAppBar(),

             
              if (showSkeleton) const NotificationSkeletonSliver(),

             
              if (!showSkeleton && isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: NotificationEmptyStateWidget(),
                ),

             
              if (!showSkeleton && !isEmpty) const NotificationListSection(),

            
               const NotificationLoadingMore(),

              
              if (!showSkeleton && !isEmpty) SliverVGap(24),
            ],
          ),
        );
      }),
    );
  }
}
