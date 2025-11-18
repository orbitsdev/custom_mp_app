import 'dart:convert';
import 'cart_product_model.dart';

class CartVariantModel {
  final int id;
  final String name;
  final double price;
  final double compareAtPrice;
  final String media;
  final CartProductModel product;

  CartVariantModel({
    required this.id,
    required this.name,
    required this.price,
    required this.compareAtPrice,
    required this.media,
    required this.product,
  });

  factory CartVariantModel.fromMap(Map<String, dynamic> map) {
    return CartVariantModel(
      id: map['id'],
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      compareAtPrice: (map['compare_at_price'] ?? 0).toDouble(),
      media: map['media'] ?? '',
      product: CartProductModel.fromMap(map['product']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'compare_at_price': compareAtPrice,
      'media': media,
      'product': product.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
  factory CartVariantModel.fromJson(String source) =>
      CartVariantModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CartVariantModel(id: $id, name: $name, price: $price, product: $product)';
}
