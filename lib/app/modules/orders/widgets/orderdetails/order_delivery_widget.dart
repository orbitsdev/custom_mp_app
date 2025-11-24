import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:flutter/material.dart';

class OrderDeliveryWidget extends StatelessWidget {
  final OrderModel order;

  const OrderDeliveryWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
