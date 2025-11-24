import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_header_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_items_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_delivery_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_pickup_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_package_widget.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orderdetails/order_payment_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get order from route arguments
    final OrderModel order = Get.arguments as OrderModel;

    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
  }
}
