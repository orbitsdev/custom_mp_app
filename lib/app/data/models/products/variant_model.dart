class VariantModel {
  final int id;
  final String name;
  final String sku;
  final double? price;
  final double? compareAtPrice;
  final int? availableStock;
  final double? weightKg;
  final double? lengthCm;
  final double? widthCm;
  final double? heightCm;
  final String media;
  final List<int>? optionIds;

  const VariantModel({
    required this.id,
    required this.name,
    required this.sku,
    this.price,
    this.compareAtPrice,
    this.availableStock,
    this.weightKg,
    this.lengthCm,
    this.widthCm,
    this.heightCm,
    required this.media,
    this.optionIds,
  });

  factory VariantModel.fromMap(Map<String, dynamic> map) {
    return VariantModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
      price: (map['price'] as num?)?.toDouble(),
      compareAtPrice: (map['compare_at_price'] as num?)?.toDouble(),
      availableStock: map['available_stock'],
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      lengthCm: (map['length_cm'] as num?)?.toDouble(),
      widthCm: (map['width_cm'] as num?)?.toDouble(),
      heightCm: (map['height_cm'] as num?)?.toDouble(),
      media: map['media'] ?? '',
      optionIds: map['option_ids'] != null
          ? List<int>.from(map['option_ids'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'sku': sku,
        'price': price,
        'compare_at_price': compareAtPrice,
        'available_stock': availableStock,
        'weight_kg': weightKg,
        'length_cm': lengthCm,
        'width_cm': widthCm,
        'height_cm': heightCm,
        'media': media,
        'option_ids': optionIds,
      };
}
