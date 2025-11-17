import 'cart_item_model.dart';

class CartResponseModel {
  final List<CartItemModel> items;
  final int totalQuantity;

  CartResponseModel({
    required this.items,
    required this.totalQuantity,
  });

  factory CartResponseModel.fromMap(Map<String, dynamic> map) {
    return CartResponseModel(
      items: (map['items'] as List)
          .map((item) => CartItemModel.fromMap(item))
          .toList(),
      totalQuantity: map['total_quantity'] ?? 0,
    );
  }
}
