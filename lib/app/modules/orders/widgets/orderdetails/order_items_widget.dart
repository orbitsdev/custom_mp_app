import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:flutter/material.dart';

class OrderItemsWidget extends StatelessWidget {
  final OrderModel order;

  const OrderItemsWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  /// Helper method to safely parse numeric values
  num _parseNumeric(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
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
          ...order.cartItemsSnapshot.map((item) => _OrderItemTile(
                item: item,
                parseNumeric: _parseNumeric,
              )),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final num Function(dynamic) parseNumeric;

  const _OrderItemTile({
    Key? key,
    required this.item,
    required this.parseNumeric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    final price = parseNumeric(item['variant_price_snapshot']);
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
}
