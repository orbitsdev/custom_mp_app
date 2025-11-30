class ReviewUserModel {
  final int id;
  final String name;
  final String? avatarUrl;

  const ReviewUserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory ReviewUserModel.fromMap(Map<String, dynamic> map) {
    return ReviewUserModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name']?.toString() ?? 'Anonymous',
      avatarUrl: map['avatar_url']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }

  @override
  String toString() {
    return 'ReviewUserModel(id: $id, name: $name)';
  }
}
