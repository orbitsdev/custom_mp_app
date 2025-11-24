import 'package:flutter/material.dart';
import 'package:custom_mp_app/app/core/enums/order_status.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final bool isCompact;

  const OrderStatusBadge({
    Key? key,
    required this.status,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: isCompact ? 14 : 16,
            color: _getStatusColor(status),
          ),
          SizedBox(width: isCompact ? 4 : 6),
          Text(
            _getStatusText(status),
            style: TextStyle(
              color: _getStatusColor(status),
              fontWeight: FontWeight.w600,
              fontSize: isCompact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return Colors.orange;
      case OrderStatus.processing:
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.paid:
        return Colors.green;
      case OrderStatus.outForDelivery:
        return Colors.purple;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.grey;
      case OrderStatus.readyForPickup:
        return Colors.teal;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.placed:
        return Icons.schedule;
      case OrderStatus.processing:
      case OrderStatus.preparing:
        return Icons.kitchen;
      case OrderStatus.paid:
        return Icons.payment;
      case OrderStatus.outForDelivery:
        return Icons.local_shipping;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.returned:
        return Icons.keyboard_return;
      case OrderStatus.readyForPickup:
        return Icons.store;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
    }
  }
}
