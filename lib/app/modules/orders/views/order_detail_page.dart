import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_status_badge.dart';
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
            _buildOrderHeader(order),

            const SizedBox(height: 12),

            // Order Items
            _buildOrderItems(order),

            const SizedBox(height: 12),

            // Shipping Address
            if (order.shippingAddressSnapshot != null)
              _buildShippingAddress(order),

            if (order.shippingAddressSnapshot != null)
              const SizedBox(height: 12),

            // Package Info
            if (order.packageSnapshot != null)
              _buildPackageInfo(order),

            if (order.packageSnapshot != null) const SizedBox(height: 12),

            // Payment Summary
            _buildPaymentSummary(order),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderReferenceId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Placed ${order.createdAt.human}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              OrderStatusBadge(status: order.orderStatus),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: order.isPaid ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: order.isPaid ? Colors.green : Colors.orange,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  order.isPaid ? Icons.check_circle : Icons.pending,
                  color: order.isPaid ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  order.isPaid
                      ? 'Payment Confirmed'
                      : 'Payment Pending - ${order.paymentType.toUpperCase()}',
                  style: TextStyle(
                    color: order.isPaid ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...order.cartItemsSnapshot.map((item) => _buildItemTile(item)),
        ],
      ),
    );
  }

  Widget _buildItemTile(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Product Image (if available)
          if (item['product_image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                item['product_image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          if (item['product_image'] != null) const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['product_name'] ?? 'Product',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (item['variant_name'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item['variant_name'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item['quantity']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '₱${(item['price'] as num).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.brandDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress(OrderModel order) {
    final address = order.shippingAddressSnapshot!;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.brandDark, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            address['name'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address['phone'] ?? '',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            [
              address['address'],
              address['city'],
              address['state'],
              address['zipcode'],
              address['country'],
            ].where((e) => e != null && e.toString().isNotEmpty).join(', '),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageInfo(OrderModel order) {
    final package = order.packageSnapshot!;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, color: AppColors.brandDark, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Shipping Package',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                package['name'] ?? 'Standard Package',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '₱${(package['price'] as num).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (package['description'] != null) ...[
            const SizedBox(height: 4),
            Text(
              package['description'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Subtotal', order.totalItemPrice),
          const SizedBox(height: 8),
          _buildPriceRow('Shipping Fee', order.shippingFee),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildPriceRow(
            'Total',
            order.totalPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, num amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        Text(
          '₱${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.brandDark : Colors.black87,
          ),
        ),
      ],
    );
  }
}
