class OrderStatusModel {
  final String orderReferenceId;
  final String deliveryStatus;
  final String? paidAt;
  final num totalPrice;

  bool get isPaid => paidAt != null;

  OrderStatusModel({
    required this.orderReferenceId,
    required this.deliveryStatus,
    required this.paidAt,
    required this.totalPrice,
  });

  factory OrderStatusModel.fromMap(Map<String, dynamic> map) {
    return OrderStatusModel(
      orderReferenceId: map['order_reference_id'] ?? '',
      deliveryStatus: map['delivery_status'] ?? '',
      paidAt: map['paid_at'],
      totalPrice: map['total_price'] ?? 0,
    );
  }
}
