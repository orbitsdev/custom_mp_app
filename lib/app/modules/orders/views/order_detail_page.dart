import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  /// Helper method to safely parse numeric values
  num _parseNumeric(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// Get user-friendly status message (Shopee-like)
  String _getStatusMessage(OrderModel order) {
    switch (order.orderStatus) {
      case OrderStatus.placed:
        return order.isPaid ? 'Order placed - Payment confirmed' : 'Waiting for payment';
      case OrderStatus.paid:
        return 'Payment confirmed - Waiting for seller';
      case OrderStatus.processing:
        return 'Order is being prepared';
      case OrderStatus.preparing:
        return 'Order is being prepared'; // Same as processing
      case OrderStatus.outForDelivery:
        return 'Order is out for delivery';
      case OrderStatus.readyForPickup:
        return 'Order is ready for pickup';
      case OrderStatus.delivered:
        return 'Order has been delivered';
      case OrderStatus.completed:
        return 'Order completed';
      case OrderStatus.cancelled:
        return 'Order was cancelled';
      case OrderStatus.returned:
        return 'Order was returned';
      default:
        return 'Order status: ${order.orderStatus.value}';
    }
  }

  /// Get status helper text
  String? _getStatusHelperText(OrderModel order) {
    switch (order.orderStatus) {
      case OrderStatus.placed:
        if (!order.isPaid) {
          return 'Please complete your payment to proceed with your order.';
        }
        return null;
      case OrderStatus.paid:
        return 'The seller will confirm your order soon.';
      case OrderStatus.processing:
        return 'Your order is being prepared for shipment.';
      case OrderStatus.outForDelivery:
        return 'Your order is on the way to your address.';
      case OrderStatus.readyForPickup:
        return 'You can now pick up your order at our store.';
      case OrderStatus.delivered:
        return 'Thank you for your order! You can rate your experience.';
      case OrderStatus.completed:
        return 'This order has been completed.';
      default:
        return null;
    }
  }

  /// Get status color
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.orange;
      case OrderStatus.paid:
        return Colors.blue;
      case OrderStatus.processing:
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.outForDelivery:
      case OrderStatus.readyForPickup:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  /// Get status icon
  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.receipt_long;
      case OrderStatus.paid:
        return Icons.check_circle;
      case OrderStatus.processing:
      case OrderStatus.preparing:
        return Icons.inventory_2;
      case OrderStatus.outForDelivery:
        return Icons.local_shipping;
      case OrderStatus.readyForPickup:
        return Icons.store;
      case OrderStatus.delivered:
        return Icons.home;
      case OrderStatus.completed:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.returned:
        return Icons.assignment_return;
      default:
        return Icons.info;
    }
  }

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

            // Shipping Address (for delivery) or Pickup Info
            if (order.deliveryType == 'delivery')
              _buildDeliverySection(order)
            else if (order.deliveryType == 'pickup')
              _buildPickupSection(order),

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
    final statusMessage = _getStatusMessage(order);
    final helperText = _getStatusHelperText(order);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Status Badge
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

          // Status Message Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(order.orderStatus).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStatusColor(order.orderStatus).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(order.orderStatus),
                      color: _getStatusColor(order.orderStatus),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        statusMessage,
                        style: TextStyle(
                          color: _getStatusColor(order.orderStatus),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                if (helperText != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    helperText,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Payment Method Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                order.paymentType.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Delivery Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Type',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                order.deliveryType == 'delivery' ? 'Home Delivery' : 'Store Pickup',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
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
    // Extract data according to actual API structure
    final variant = item['variant'] as Map<String, dynamic>?;
    final product = variant?['product'] as Map<String, dynamic>?;

    // Get thumbnail: Try variant media first, then product media
    String? imageUrl;

    // Check if variant has media array
    if (variant?['media'] != null && variant!['media'] is List && (variant['media'] as List).isNotEmpty) {
      final mediaList = variant['media'] as List;
      imageUrl = mediaList.first['original_url']?.toString();
    }

    // Fallback to product media if variant has no media
    if (imageUrl == null && product?['media'] != null && product!['media'] is List && (product['media'] as List).isNotEmpty) {
      final productMediaList = product['media'] as List;
      imageUrl = productMediaList.first['original_url']?.toString();
    }

    // Get product name from variant.product.name
    final productName = product?['name']?.toString() ?? 'Product';

    // Get variant name from variant.name
    final variantName = variant?['name']?.toString();

    final quantity = item['quantity'] ?? 0;
    // Price: Use 'variant_price_snapshot' field from API
    final price = _parseNumeric(item['variant_price_snapshot']);
    final subtotal = price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image (thumbnail)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 30),
                    ),
                  )
                : Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.shopping_bag, size: 30),
                  ),
          ),
          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (variantName != null && variantName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Variant: $variantName',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₱${price.toStringAsFixed(2)} × $quantity',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '₱${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(OrderModel order) {
    // If no address snapshot, show a message
    if (order.shippingAddressSnapshot == null) {
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
              'Delivery address not available',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    final address = order.shippingAddressSnapshot!;

    // Get address fields based on actual API response
    final name = address['full_name']?.toString() ?? 'Recipient';
    final phone = address['phone_number']?.toString() ?? '';
    final street = address['street']?.toString() ?? '';
    final landmark = address['landmark']?.toString() ?? '';
    final postalCode = address['postal_code']?.toString() ?? '';

    // Extract nested location objects
    final barangay = address['barangay'] != null ? address['barangay']['name']?.toString() ?? '' : '';
    final municipality = address['municipality'] != null ? address['municipality']['name']?.toString() ?? '' : '';
    final province = address['province'] != null ? address['province']['name']?.toString() ?? '' : '';
    final region = address['region'] != null ? address['region']['name']?.toString() ?? '' : '';

    // Build full address string
    final fullAddress = [
      street,
      landmark.isNotEmpty ? 'Landmark: $landmark' : '',
      barangay,
      municipality,
      province,
      region,
      postalCode.isNotEmpty ? 'Postal Code: $postalCode' : '',
    ].where((e) => e.isNotEmpty).join(', ');

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
          if (name.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (phone.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (fullAddress.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.home_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    fullAddress,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
          // If no address data available
          if (fullAddress.isEmpty && phone.isEmpty && name == 'Recipient') ...[
            Text(
              'No address information available',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPickupSection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.store, color: AppColors.brandDark, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Pickup Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This order is for store pickup. Please pick up your order at our store location.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
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
                '₱${_parseNumeric(package['price']).toStringAsFixed(2)}',
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
