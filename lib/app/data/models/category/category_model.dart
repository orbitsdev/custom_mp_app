class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? bgColor;
  final String? thumbnail;
  final String? orderStartsAt;
  final String? orderEndsAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.bgColor,
    this.thumbnail,
    this.orderStartsAt,
    this.orderEndsAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      description: map['description'],
      bgColor: map['bg_color'],
      thumbnail: map['thumbnail'],
      orderStartsAt: map['order_starts_at'],
      orderEndsAt: map['order_ends_at'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
        'bg_color': bgColor,
        'thumbnail': thumbnail,
        'order_starts_at': orderStartsAt,
        'order_ends_at': orderEndsAt,
      };

  @override
  String toString() => 'CategoryModel(id: $id, name: $name, slug: $slug)';
}
