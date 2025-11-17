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
      name: map['name'],
      slug: map['slug'],
      thumbnail: map['thumbnail'] ?? '',
    );
  }
}
