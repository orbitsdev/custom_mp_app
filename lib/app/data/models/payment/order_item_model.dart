class OrderItemModel {
  final int id;
  final String productName;
  final String? variantName;
  final int quantity;
  final double price;
  final double subtotal;

  OrderItemModel({
    required this.id,
    required this.productName,
    this.variantName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] as int,
      productName: map['product_name'] as String,
      variantName: map['variant_name'] as String?,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'OrderItemModel(id: $id, productName: $productName, variantName: $variantName, quantity: $quantity, price: $price, subtotal: $subtotal)';
  }
}
