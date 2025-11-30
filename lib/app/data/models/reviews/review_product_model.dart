/// Minimal product model for review responses
/// This is different from the full ProductModel - only contains basic info
class ReviewProductModel {
  final int id;
  final String name;
  final String slug;
  final String thumbnail;

  const ReviewProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.thumbnail,
  });

  factory ReviewProductModel.fromMap(Map<String, dynamic> map) {
    return ReviewProductModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name']?.toString() ?? '',
      slug: map['slug']?.toString() ?? '',
      thumbnail: map['thumbnail']?.toString() ?? '',
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

  @override
  String toString() {
    return 'ReviewProductModel(id: $id, name: $name)';
  }
}
