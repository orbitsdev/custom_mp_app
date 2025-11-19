class CartSummaryModel {
  final int totalItems;
  final int selectedCount;
  final double subtotal;
  final double discount;
  final double shippingFee;
  final double grandTotal;

  CartSummaryModel({
    required this.totalItems,
    required this.selectedCount,
    required this.subtotal,
    required this.discount,
    required this.shippingFee,
    required this.grandTotal,
  });

  factory CartSummaryModel.fromMap(Map<String, dynamic> map) {
    return CartSummaryModel(
      totalItems: map['total_items'] ?? 0,
      selectedCount: map['selected_count'] ?? 0,
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      shippingFee: (map['shipping_fee'] ?? 0).toDouble(),
      grandTotal: (map['grand_total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_items': totalItems,
      'selected_count': selectedCount,
      'subtotal': subtotal,
      'discount': discount,
      'shipping_fee': shippingFee,
      'grand_total': grandTotal,
    };
  }
}
