class OrderStatusModel {
  final String orderReferenceId;
  final String status;
  final String? paidAt;
  final num totalPrice;

  bool get isPaid => status == "paid" || paidAt != null;

  OrderStatusModel({
    required this.orderReferenceId,
    required this.status,
    required this.paidAt,
    required this.totalPrice,
  });

  factory OrderStatusModel.fromMap(Map<String, dynamic> map) {
    return OrderStatusModel(
      orderReferenceId: map['order_reference_id'],
      status: map['status'],
      paidAt: map['paid_at'],
      totalPrice: map['total_price'],
    );
  }
}
