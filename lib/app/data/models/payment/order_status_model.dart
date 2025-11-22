import 'package:custom_mp_app/app/data/models/payment/order_item_model.dart';

class OrderStatusModel {
  final String orderReferenceId;
  final String status;
  final DateTime? paidAt;
  final double totalAmount;
  final List<OrderItemModel> items;

  OrderStatusModel({
    required this.orderReferenceId,
    required this.status,
    this.paidAt,
    required this.totalAmount,
    required this.items,
  });

  factory OrderStatusModel.fromMap(Map<String, dynamic> map) {
    return OrderStatusModel(
      orderReferenceId: map['order_reference_id'] as String,
      status: map['status'] as String,
      paidAt: map['paid_at'] != null
          ? DateTime.parse(map['paid_at'] as String)
          : null,
      totalAmount: (map['total_amount'] as num).toDouble(),
      items: map['items'] != null
          ? List<OrderItemModel>.from(
              (map['items'] as List).map((x) => OrderItemModel.fromMap(x)))
          : [],
    );
  }

  bool get isPaid => status.toLowerCase() == 'paid';

  @override
  String toString() {
    return 'OrderStatusModel(orderReferenceId: $orderReferenceId, status: $status, paidAt: $paidAt, totalAmount: $totalAmount, items: ${items.length})';
  }
}
