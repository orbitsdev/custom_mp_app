import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_status_badge.dart';
import 'package:flutter/material.dart';

class OrderHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const OrderHeaderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

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
        return 'Order is being prepared';
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
}
