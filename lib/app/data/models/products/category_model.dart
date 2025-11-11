class CategoryModel {
  final int id;
  final String name;
  final String slug;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'slug': slug,
      };
}
