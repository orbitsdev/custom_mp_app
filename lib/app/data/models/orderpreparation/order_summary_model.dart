// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderPreparationSummaryModel {
  final num subtotal;
  final num packagingFee;
  final num shippingFee;
  final num total;

  OrderPreparationSummaryModel({
    required this.subtotal,
    required this.packagingFee,
    required this.shippingFee,
    required this.total,
  });

  //from map
  factory OrderPreparationSummaryModel.fromMap(Map<String, dynamic> map) {
    return OrderPreparationSummaryModel(
      subtotal: map['subtotal'] as num,
      packagingFee: map['packaging_fee'] as num,
      shippingFee: map['shipping_fee'] as num,
      total: map['total'] as num,
    );
  }

  OrderPreparationSummaryModel copyWith({
    num? subtotal,
    num? packagingFee,
    num? shippingFee,
    num? total,
  }) {
    return OrderPreparationSummaryModel(
      subtotal: subtotal ?? this.subtotal,
      packagingFee: packagingFee ?? this.packagingFee,
      shippingFee: shippingFee ?? this.shippingFee,
      total: total ?? this.total,
    );
  }

  @override
  String toString() {
    return 'OrderPreparationSummaryModel(subtotal: $subtotal, packagingFee: $packagingFee, shippingFee: $shippingFee, total: $total)';
  }
}
