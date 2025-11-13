import 'package:custom_mp_app/app/data/models/products/option_model.dart';

class AttributeModel {
  final int id;
  final String name;
  final List<OptionModel> options;

  const AttributeModel({
    required this.id,
    required this.name,
    required this.options,
  });

  factory AttributeModel.fromMap(Map<String, dynamic> map) {
    return AttributeModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      options: (map['options'] is List)
          ? (map['options'] as List)
              .map((e) => OptionModel.fromMap(e))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'options': options.map((e) => e.toMap()).toList(),
      };
}
