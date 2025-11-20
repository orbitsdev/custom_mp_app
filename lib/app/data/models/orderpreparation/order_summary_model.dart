class OrderPreparationSummaryModel {
  final double subtotal;
  final double packagingFee;
  final double shippingFee;
  final double total;

  OrderPreparationSummaryModel({
    required this.subtotal,
    required this.packagingFee,
    required this.shippingFee,
    required this.total,
  });

  factory OrderPreparationSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderPreparationSummaryModel(
      subtotal: (json['subtotal'] as num).toDouble(),
      packagingFee: (json['packaging_fee'] as num).toDouble(),
      shippingFee: (json['shipping_fee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}
