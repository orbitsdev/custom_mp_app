import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderStatusFilterTabs extends StatelessWidget {
  final OrderStatus? selectedStatus;
  final Function(OrderStatus?) onStatusSelected;

  const OrderStatusFilterTabs({
    Key? key,
    required this.selectedStatus,
    required this.onStatusSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            label: 'All',
            isSelected: selectedStatus == null,
            onTap: () => onStatusSelected(null),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Pending',
            isSelected: selectedStatus == OrderStatus.pending,
            onTap: () => onStatusSelected(OrderStatus.pending),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Processing',
            isSelected: selectedStatus == OrderStatus.processing,
            onTap: () => onStatusSelected(OrderStatus.processing),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Preparing',
            isSelected: selectedStatus == OrderStatus.preparing,
            onTap: () => onStatusSelected(OrderStatus.preparing),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Delivery',
            isSelected: selectedStatus == OrderStatus.outForDelivery,
            onTap: () => onStatusSelected(OrderStatus.outForDelivery),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Completed',
            isSelected: selectedStatus == OrderStatus.completed,
            onTap: () => onStatusSelected(OrderStatus.completed),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandDark : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.brandDark : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
