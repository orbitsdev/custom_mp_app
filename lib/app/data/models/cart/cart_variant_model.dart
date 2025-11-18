// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'cart_product_model.dart';

class CartVariantModel {
  final int id;
  final String name;
  final double price;
  final double compareAtPrice;
  final String media;
  final int availableStock;
  final bool isDefault;
  final CartProductModel product;

  CartVariantModel({
    required this.id,
    required this.name,
    required this.price,
    required this.compareAtPrice,
    required this.media,
    required this.availableStock,
    this.isDefault = false,
    required this.product,
  });

  factory CartVariantModel.fromMap(Map<String, dynamic> map) {
    return CartVariantModel(
      id: map['id'],
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      compareAtPrice: (map['compare_at_price'] ?? 0).toDouble(),
      media: map['media'] ?? '',
      availableStock: map['available_stock'] ?? 0,
      isDefault: map['is_default'] ?? false,
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
      'available_stock': availableStock,
      'is_default': isDefault,
      'product': product.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
  factory CartVariantModel.fromJson(String source) => CartVariantModel.fromMap(json.decode(source));



  @override
  String toString() {
    return 'CartVariantModel(id: $id, name: $name, price: $price, compareAtPrice: $compareAtPrice, media: $media, availableStock: $availableStock, isDefault: $isDefault, product: $product)';
  }
}
