import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:flutter/material.dart';

class OrderPackageWidget extends StatelessWidget {
  final OrderModel order;

  const OrderPackageWidget({
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
    if (order.packageSnapshot == null) {
      return const SizedBox.shrink();
    }

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
}
