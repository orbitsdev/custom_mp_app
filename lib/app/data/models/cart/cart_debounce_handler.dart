import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';

class CartDebounceHandler {
  static const addQuantity = "addQuantity";
  static const removeQuantity = "removeQuantity";
  static const toggleSelect = "toggleSelect";

  final CartItemModel? item;
  final String? action;

  CartDebounceHandler({this.item, this.action});

  CartDebounceHandler copyWith({
    CartItemModel? item,
    String? action,
  }) {
    return CartDebounceHandler(
      item: item ?? this.item,
      action: action ?? this.action,
    );
  }

  @override
  String toString() =>
      "CartDebounceHandler(item: ${item?.id}, action: $action)";
}
