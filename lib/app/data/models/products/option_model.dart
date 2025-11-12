class OptionModel {
  final int id;
  final String name;
  final String? attributeName;

  OptionModel({
    required this.id,
    required this.name,
    this.attributeName,
  });

  factory OptionModel.fromMap(Map<String, dynamic> map) {
    return OptionModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      attributeName: map['attribute_name'], // from backend resource
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'attribute_name': attributeName,
    };
  }
}
