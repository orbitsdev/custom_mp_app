import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/order_detail_controller.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_header_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_items_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_delivery_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_pickup_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_package_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_payment_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailController>();

    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        backgroundColor: AppColors.brandDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        final order = controller.selectedOrder.value;
        final isLoading = controller.isLoading.value;

        // Show skeleton loader while fetching order
        if (isLoading) {
          return _buildSkeletonLoader();
        }

        // Show error if order not found
        if (order == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Order not found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unable to load order details',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Display order details
        return RefreshIndicator(
          onRefresh: controller.refreshOrder,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header Card
                OrderHeaderWidget(order: order),

                const SizedBox(height: 12),

                // Order Items
                OrderItemsWidget(order: order),

                const SizedBox(height: 12),

                // Shipping Address (for delivery) or Pickup Info
                if (order.deliveryType == 'delivery')
                  OrderDeliveryWidget(order: order)
                else if (order.deliveryType == 'pickup')
                  const OrderPickupWidget(),

                const SizedBox(height: 12),

                // Package Info
                OrderPackageWidget(order: order),

                const SizedBox(height: 12),

                // Payment Summary
                OrderPaymentSummaryWidget(order: order),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Skeleton loader matching actual order detail layout
  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header Card Skeleton
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    width: 120,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Order number
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  // Order date
                  Container(
                    width: 100,
                    height: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Order Items Card Skeleton
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Container(
                    width: 100,
                    height: 18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  // Item 1
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 100,
                              height: 14,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Item 2
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 100,
                              height: 14,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Delivery Address Card Skeleton
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    width: 120,
                    height: 18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  // Address lines
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 200,
                    height: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 150,
                    height: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Package Info Card Skeleton
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 180,
                    height: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Payment Summary Card Skeleton
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    width: 140,
                    height: 18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  // Price rows
                  _buildPriceRowSkeleton(),
                  const SizedBox(height: 8),
                  _buildPriceRowSkeleton(),
                  const SizedBox(height: 8),
                  _buildPriceRowSkeleton(),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  // Total row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 18,
                        color: Colors.grey.shade400,
                      ),
                      Container(
                        width: 100,
                        height: 18,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRowSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          height: 14,
          color: Colors.grey.shade400,
        ),
        Container(
          width: 80,
          height: 14,
          color: Colors.grey.shade400,
        ),
      ],
    );
  }
}
