import 'package:custom_mp_app/app/data/models/products/option_model.dart';

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

  /// IMPORTANT: This MUST be int
  final List<int> optionIds;

  final List<OptionModel> options;

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
    required this.optionIds,
    this.options = const [],
  });

  factory VariantModel.fromMap(Map<String, dynamic> map) {
    int _asInt(dynamic v) {
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    double? _asDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    List<int> _asListOfInt(dynamic v) {
      if (v is List) {
        return v.map((e) {
          if (e is int) return e;
          if (e is String) return int.tryParse(e) ?? 0;
          return 0;
        }).toList();
      }
      return [];
    }

    return VariantModel(
      id: _asInt(map['id']),
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
      price: _asDouble(map['price']),
      compareAtPrice: _asDouble(map['compare_at_price']),
      availableStock: _asInt(map['available_stock']),
      weightKg: _asDouble(map['weight_kg']),
      lengthCm: _asDouble(map['length_cm']),
      widthCm: _asDouble(map['width_cm']),
      heightCm: _asDouble(map['height_cm']),
      media: map['media']?.toString() ?? '',
      optionIds: _asListOfInt(map['option_ids']),
      options: (map['options'] as List?)
              ?.map((e) => OptionModel.fromMap(e))
              .toList() ??
          [],
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
        'options': options.map((e) => e.toMap()).toList(),
      };
}
