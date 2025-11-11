import 'package:custom_mp_app/app/data/models/category/category_model.dart';
import 'variant_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String? shortDescription;
  final String? description;
  final String? nutritionFacts;
  final double? price;
  final double? compareAtPrice;
  final bool isFeatured;
  final bool isBestSeller;
  final String? newArrivalEndsAt;
  final int? views;
  final int? sold;
  final int? minPrepTime;
  final String? minPrepTimeUnit;
  final int? maxPrepTime;
  final String? maxPrepTimeUnit;
  final String thumbnail;
  final List<String> gallery;
  final List<CategoryModel> categories;
  final List<VariantModel> variants;

  const ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    this.shortDescription,
    this.description,
    this.nutritionFacts,
    this.price,
    this.compareAtPrice,
    required this.isFeatured,
    required this.isBestSeller,
    this.newArrivalEndsAt,
    this.views,
    this.sold,
    this.minPrepTime,
    this.minPrepTimeUnit,
    this.maxPrepTime,
    this.maxPrepTimeUnit,
    required this.thumbnail,
    required this.gallery,
    required this.categories,
    required this.variants,
  });

  /// ✅ Safe, type-flexible factory that avoids any runtime cast errors.
  factory ProductModel.fromMap(Map<String, dynamic> map) {
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

    List<T> _asListOf<T>(dynamic v) {
      if (v is List) return v.cast<T>();
      return const [];
    }

    final rawCats = map['categories'];
    final rawVars = map['variants'];

    return ProductModel(
      id: _asInt(map['id']),
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      shortDescription: map['short_description'],
      description: map['description'],
      nutritionFacts: map['nutrition_facts'],
      price: _asDouble(map['price']),
      compareAtPrice: _asDouble(map['compare_at_price']),
      isFeatured: (map['is_featured'] ?? false) == true,
      isBestSeller: (map['is_best_seller'] ?? false) == true,
      newArrivalEndsAt: map['new_arrival_ends_at']?.toString(),
      views: (map['views'] as num?)?.toInt(),
      sold: (map['sold'] as num?)?.toInt(),
      minPrepTime: (map['min_prep_time'] as num?)?.toInt(),
      minPrepTimeUnit: map['min_prep_time_unit']?.toString(),
      maxPrepTime: (map['max_prep_time'] as num?)?.toInt(),
      maxPrepTimeUnit: map['max_prep_time_unit']?.toString(),
      thumbnail: map['thumbnail']?.toString() ?? '',
      gallery: _asListOf<String>(map['gallery']),
      categories: (rawCats is List)
          ? rawCats
              .map((e) => CategoryModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : const [],
      variants: (rawVars is List)
          ? rawVars
              .map((e) => VariantModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'slug': slug,
        'short_description': shortDescription,
        'description': description,
        'nutrition_facts': nutritionFacts,
        'price': price,
        'compare_at_price': compareAtPrice,
        'is_featured': isFeatured,
        'is_best_seller': isBestSeller,
        'new_arrival_ends_at': newArrivalEndsAt,
        'views': views,
        'sold': sold,
        'min_prep_time': minPrepTime,
        'min_prep_time_unit': minPrepTimeUnit,
        'max_prep_time': maxPrepTime,
        'max_prep_time_unit': maxPrepTimeUnit,
        'thumbnail': thumbnail,
        'gallery': gallery,
        'categories': categories.map((e) => e.toMap()).toList(),
        'variants': variants.map((e) => e.toMap()).toList(),
      };
}
