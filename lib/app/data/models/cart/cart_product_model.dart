import 'dart:convert';

class CartProductModel {
  final int id;
  final String name;
  final String slug;
  final String thumbnail;

  CartProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.thumbnail,
  });

  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      id: map['id'],
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'thumbnail': thumbnail,
    };
  }

  String toJson() => json.encode(toMap());
  factory CartProductModel.fromJson(String source) =>
      CartProductModel.fromMap(json.decode(source));

  @override
  String toString() => 'Product(id: $id, name: $name, slug: $slug)';
}
