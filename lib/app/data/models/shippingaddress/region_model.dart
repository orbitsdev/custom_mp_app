class RegionModel {
  final String code;
  final String? name;

  RegionModel({
    required this.code,
    this.name,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      code: json['code'],
      name: json['name'],
    );
  }
}
