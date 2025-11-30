/// Flexible query parameters for product API requests
/// Supports all backend API filtering, sorting, and pagination capabilities
class ProductQueryParams {
  // Pagination
  final int page;
  final int perPage;

  // Search & Filters
  final String? search;
  final String? name;
  final List<int>? categoryIds;
  final double? priceMin;
  final double? priceMax;
  final bool? isFeatured;
  final bool? isBestSeller;
  final bool? isNewArrival;
  final bool? inStock;

  // Sorting
  final ProductSortOption? sortBy;

  // Includes (relations)
  final List<String>? includes;

  ProductQueryParams({
    this.page = 1,
    this.perPage = 15,
    this.search,
    this.name,
    this.categoryIds,
    this.priceMin,
    this.priceMax,
    this.isFeatured,
    this.isBestSeller,
    this.isNewArrival,
    this.inStock,
    this.sortBy,
    this.includes,
  });

  /// Convert to query parameters map for API request
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    // Search filter
    if (search != null && search!.isNotEmpty) {
      params['filter[search]'] = search;
    }

    // Name filter
    if (name != null && name!.isNotEmpty) {
      params['filter[name]'] = name;
    }

    // Category filter - IMPORTANT: Use filter[categories][] NOT filter[category_id]
    if (categoryIds != null && categoryIds!.isNotEmpty) {
      for (var i = 0; i < categoryIds!.length; i++) {
        params['filter[categories][$i]'] = categoryIds![i];
      }
    }

    // Price range filters
    if (priceMin != null) {
      // Client-side validation (API also validates)
      if (priceMin! < 0) {
        throw ArgumentError('priceMin must be non-negative');
      }
      params['filter[price_min]'] = priceMin;
    }

    if (priceMax != null) {
      // Client-side validation (API also validates)
      if (priceMax! < 0) {
        throw ArgumentError('priceMax must be non-negative');
      }
      params['filter[price_max]'] = priceMax;
    }

    // Status filters
    if (isFeatured != null && isFeatured!) {
      params['filter[is_featured]'] = 1;
    }

    if (isBestSeller != null && isBestSeller!) {
      params['filter[is_best_seller]'] = 1;
    }

    if (isNewArrival != null && isNewArrival!) {
      params['filter[is_new_arrival]'] = 1;
    }

    if (inStock != null && inStock!) {
      params['filter[in_stock]'] = 1;
    }

    // Sorting
    if (sortBy != null) {
      params['sort'] = sortBy!.value;
    }

    // Includes (load relations)
    if (includes != null && includes!.isNotEmpty) {
      params['include'] = includes!.join(',');
    }

    return params;
  }

  /// Create a copy with updated values
  ProductQueryParams copyWith({
    int? page,
    int? perPage,
    String? search,
    String? name,
    List<int>? categoryIds,
    double? priceMin,
    double? priceMax,
    bool? isFeatured,
    bool? isBestSeller,
    bool? isNewArrival,
    bool? inStock,
    ProductSortOption? sortBy,
    List<String>? includes,
  }) {
    return ProductQueryParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      name: name ?? this.name,
      categoryIds: categoryIds ?? this.categoryIds,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      isFeatured: isFeatured ?? this.isFeatured,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      inStock: inStock ?? this.inStock,
      sortBy: sortBy ?? this.sortBy,
      includes: includes ?? this.includes,
    );
  }

  /// Factory: Get all products (default)
  factory ProductQueryParams.all({
    int page = 1,
    int perPage = 15,
  }) {
    return ProductQueryParams(
      page: page,
      perPage: perPage,
      includes: [
        'media',
        'categories',
        'variants.media',
        'variants.options.attribute',
        'attributes.options',
      ],
    );
  }

  /// Factory: Search products
  factory ProductQueryParams.search(
    String keyword, {
    int page = 1,
    int perPage = 15,
  }) {
    return ProductQueryParams(
      page: page,
      perPage: perPage,
      search: keyword,
      includes: ['media', 'categories', 'variants'],
    );
  }

  /// Factory: Filter by category
  factory ProductQueryParams.byCategory(
    List<int> categoryIds, {
    int page = 1,
    int perPage = 15,
  }) {
    return ProductQueryParams(
      page: page,
      perPage: perPage,
      categoryIds: categoryIds,
      includes: ['media', 'categories', 'variants'],
    );
  }

  /// Factory: Featured products
  factory ProductQueryParams.featured({
    int page = 1,
    int perPage = 15,
  }) {
    return ProductQueryParams(
      page: page,
      perPage: perPage,
      isFeatured: true,
      includes: ['media', 'categories', 'variants'],
    );
  }

  /// Factory: Best sellers
  factory ProductQueryParams.bestSellers({
    int page = 1,
    int perPage = 15,
  }) {
    return ProductQueryParams(
      page: page,
      perPage: perPage,
      isBestSeller: true,
      sortBy: ProductSortOption.mostSold,
      includes: ['media', 'categories', 'variants'],
    );
  }

  /// Factory: New arrivals
  factory ProductQueryParams.newArrivals({
    int page = 1,
    int perPage = 15,
  }) {
    return ProductQueryParams(
      page: page,
      perPage: perPage,
      isNewArrival: true,
      sortBy: ProductSortOption.newest,
      includes: ['media', 'categories', 'variants'],
    );
  }

  /// Factory: Price range
  factory ProductQueryParams.priceRange(
    double min,
    double max, {
    int page = 1,
    int perPage = 15,
  }) {
    return ProductQueryParams(
      page: page,
      perPage: perPage,
      priceMin: min,
      priceMax: max,
      sortBy: ProductSortOption.priceLowToHigh,
      includes: ['media', 'categories', 'variants'],
    );
  }

  @override
  String toString() {
    return 'ProductQueryParams(page: $page, perPage: $perPage, '
        'search: $search, categoryIds: $categoryIds, '
        'priceMin: $priceMin, priceMax: $priceMax, '
        'sortBy: $sortBy)';
  }
}

/// Available sorting options for products
enum ProductSortOption {
  /// Sort by name A-Z
  nameAsc('name'),

  /// Sort by name Z-A
  nameDesc('-name'),

  /// Sort by newest first (default)
  newest('-created_at'),

  /// Sort by oldest first
  oldest('created_at'),

  /// Sort by most popular (views)
  mostPopular('-views'),

  /// Sort by least popular
  leastPopular('views'),

  /// Sort by most sold
  mostSold('-sold'),

  /// Sort by least sold
  leastSold('sold'),

  /// Sort by price: low to high
  priceLowToHigh('price_low'),

  /// Sort by price: high to low
  priceHighToLow('price_high'),

  /// Sort by featured status
  featured('-is_featured');

  const ProductSortOption(this.value);

  final String value;

  @override
  String toString() => value;
}

/// Common include presets for loading relations
class ProductIncludes {
  /// Basic includes (media, categories, variants)
  static const List<String> basic = [
    'media',
    'categories',
    'variants',
  ];

  /// Full includes (everything)
  static const List<String> full = [
    'media',
    'categories',
    'variants',
    'variants.media',
    'variants.options',
    'variants.options.attribute',
    'attributes',
    'attributes.options',
    'reviews',
    'reviews.user',
    'reviews.media',
  ];

  /// Minimal (no relations)
  static const List<String> minimal = [];

  /// Only media
  static const List<String> mediaOnly = ['media'];

  /// Only variants
  static const List<String> variantsOnly = ['variants', 'variants.media'];
}
