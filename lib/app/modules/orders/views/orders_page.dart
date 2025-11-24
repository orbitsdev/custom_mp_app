import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_card.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_status_filter_tabs.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orders_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      body: RefreshIndicator(
        onRefresh: controller.refreshOrders,
        child: Obx(
          () => CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'My Orders',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: OrderStatusFilterTabs(
                    selectedStatus: controller.selectedStatus.value,
                    onStatusSelected: controller.filterByStatus,
                  ),
                ),
              ),

              // Loading State (Initial)
              if (controller.isLoading.value && controller.orders.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.brandDark,
                    ),
                  ),
                ),

              // Empty State
              if (!controller.isLoading.value && controller.orders.isEmpty)
                const SliverFillRemaining(
                  child: OrdersEmptyState(),
                ),

              // Orders List with SliverMasonryGrid
              if (controller.orders.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverMasonryGrid.count(
                    childCount: controller.orders.length,
                    crossAxisCount: 1,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 0,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      return OrderCard(
                        order: order,
                        onTap: () {
                          // TODO: Navigate to order details page
                          // Get.toNamed(Routes.ORDER_DETAIL, arguments: order);
                        },
                      );
                    },
                  ),
                ),

              // Loading More Indicator
              if (controller.isLoadingMore.value)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brandDark,
                      ),
                    ),
                  ),
                ),

              // End of List Indicator
              if (!controller.isLoadingMore.value &&
                  controller.orders.isNotEmpty &&
                  !controller.hasMorePages.value)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No more orders',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
