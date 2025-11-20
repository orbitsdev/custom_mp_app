import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegionModel {
  final String code;
  final String? name;

  RegionModel({
    required this.code,
    this.name,
  });

  factory RegionModel.fromMap(Map<String, dynamic> map) {
    return RegionModel(
      code: map['code'] as String,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  RegionModel copyWith({
    String? code,
    String? name,
  }) {
    return RegionModel(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  factory RegionModel.fromJson(String source) => RegionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RegionModel(code: $code, name: $name)';
}
