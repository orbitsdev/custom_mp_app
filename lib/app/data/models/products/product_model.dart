import 'package:custom_mp_app/app/data/models/products/category_model.dart';
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
  final int views;
  final int sold;
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
    required this.views,
    required this.sold,
    this.minPrepTime,
    this.minPrepTimeUnit,
    this.maxPrepTime,
    this.maxPrepTimeUnit,
    required this.thumbnail,
    required this.gallery,
    required this.categories,
    required this.variants,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      shortDescription: map['short_description'],
      description: map['description'],
      nutritionFacts: map['nutrition_facts'],
      price: (map['price'] as num?)?.toDouble(),
      compareAtPrice: (map['compare_at_price'] as num?)?.toDouble(),
      isFeatured: map['is_featured'] ?? false,
      isBestSeller: map['is_best_seller'] ?? false,
      newArrivalEndsAt: map['new_arrival_ends_at'],
      views: map['views'] ?? 0,
      sold: map['sold'] ?? 0,
      minPrepTime: map['min_prep_time'],
      minPrepTimeUnit: map['min_prep_time_unit'],
      maxPrepTime: map['max_prep_time'],
      maxPrepTimeUnit: map['max_prep_time_unit'],
      thumbnail: map['thumbnail'] ?? '',
      gallery: map['gallery'] != null
          ? List<String>.from(map['gallery'])
          : const [],
      categories: map['categories'] != null
          ? List<CategoryModel>.from(
              map['categories'].map((x) => CategoryModel.fromMap(x)))
          : const [],
      variants: map['variants'] != null
          ? List<VariantModel>.from(
              map['variants'].map((x) => VariantModel.fromMap(x)))
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
