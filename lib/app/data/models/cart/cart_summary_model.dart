class CartSummaryModel {
  final int totalItems;
  final int selectedCount;
  final double subtotal;
  final double discount;
  final double shippingFee;
  final double grandTotal;

  CartSummaryModel({
    this.totalItems = 0,
    this.selectedCount = 0,
    this.subtotal = 0,
    this.discount = 0,
    this.shippingFee = 0,
    this.grandTotal = 0,
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

  CartSummaryModel copyWith({
    int? totalItems,
    int? selectedCount,
    double? subtotal,
    double? discount,
    double? shippingFee,
    double? grandTotal,
  }) {
    return CartSummaryModel(
      totalItems: totalItems ?? this.totalItems,
      selectedCount: selectedCount ?? this.selectedCount,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      shippingFee: shippingFee ?? this.shippingFee,
      grandTotal: grandTotal ?? this.grandTotal,
    );
  }

  @override
  String toString() {
    return 'CartSummaryModel(totalItems: $totalItems, selectedCount: $selectedCount, subtotal: $subtotal, discount: $discount, shippingFee: $shippingFee, grandTotal: $grandTotal)';
  }

  
}
