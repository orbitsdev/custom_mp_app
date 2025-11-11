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
    int _asInt(dynamic v) {
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    String? _asString(dynamic v) {
      if (v == null) return null;
      return v.toString();
    }

    return CategoryModel(
      id: _asInt(map['id']),
      name: map['name']?.toString() ?? '',
      slug: map['slug']?.toString() ?? '',
      description: _asString(map['description']),
      bgColor: _asString(map['bg_color']),
      thumbnail: _asString(map['thumbnail']),
      orderStartsAt: _asString(map['order_starts_at']),
      orderEndsAt: _asString(map['order_ends_at']),
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
}
