import 'cart_variant_model.dart';

class CartItemModel {
  final int id;
  final int quantity;
  final CartVariantModel variant;

  CartItemModel({
    required this.id,
    required this.quantity,
    required this.variant,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      quantity: map['quantity'] ?? 1,
      variant: CartVariantModel.fromMap(map['variant']),
    );
  }
}
