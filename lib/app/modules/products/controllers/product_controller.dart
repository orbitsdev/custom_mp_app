import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';
import 'package:custom_mp_app/app/data/models/products/product_pagination_response.dart';

/// Product Controller with flexible filtering and pagination
///
/// Supports all ProductRepository capabilities:
/// - Search, filter by category, price range, status
/// - Multiple sorting options
/// - Pagination with load more
class ProductController extends GetxController {
  final ProductRepository _repo = ProductRepository();

  List<ProductModel> products = [];

  // Pagination state
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool isLoadingMore = false;

  // Current sort option (for UI display)
  final selectedSort = Rxn<ProductSortOption>();

  // Current query parameters
  ProductQueryParams _currentParams = ProductQueryParams.all();

  // Best Sellers & New Arrivals preview sections
  final bestSellers = <ProductModel>[].obs;
  final newArrivals = <ProductModel>[].obs;
  final isLoadingBestSellers = false.obs;
  final isLoadingNewArrivals = false.obs;

  bool get hasMore => currentPage < lastPage;

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
    fetchBestSellersPreview();
    fetchNewArrivalsPreview();
  }

  /// Fetch products with optional filters
  ///
  /// **Examples:**
  /// ```dart
  /// // Get all products
  /// fetchProducts();
  ///
  /// // Search products
  /// fetchProducts(params: ProductQueryParams.search('coconut'));
  ///
  /// // Filter by category
  /// fetchProducts(params: ProductQueryParams.byCategory([1]));
  ///
  /// // Custom filters
  /// fetchProducts(params: ProductQueryParams(
  ///   search: 'coffee',
  ///   priceMin: 10,
  ///   priceMax: 50,
  ///   sortBy: ProductSortOption.priceLowToHigh,
  /// ));
  /// ```
  Future<void> fetchProducts({ProductQueryParams? params}) async {
    isLoading = true;
    isLoadingMore = false;  // Reset load more state
    currentPage = 1;
    update();

    // Use provided params or default
    _currentParams = params ?? ProductQueryParams.all();

    final result = await _repo.fetchProducts(params: _currentParams);

    result.fold(
      (failure) {
        products.clear();
        print('❌ Failed to fetch products: ${failure.message}');
      },
      (pagination) {
        products = pagination.items;
        currentPage = pagination.currentPage;
        lastPage = pagination.lastPage;
        print('✅ Loaded ${pagination.items.length} products (page $currentPage/$lastPage)');
      },
    );

    isLoading = false;
    update();
  }

  /// Load next page of products
  ///
  /// Uses the same filters/sorting as the current query
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    update();

    // Load next page with same parameters
    final nextPage = currentPage + 1;
    final nextParams = _currentParams.copyWith(page: nextPage);

    final result = await _repo.fetchProducts(params: nextParams);

    result.fold(
      (failure) {
        print('❌ Failed to load more: ${failure.message}');
      },
      (pagination) {
        products.addAll(pagination.items);
        currentPage = pagination.currentPage;
        print('✅ Loaded ${pagination.items.length} more products');
      },
    );

    isLoadingMore = false;
    update();
  }

  /// Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    await fetchProducts(params: _currentParams.copyWith(page: 1));
  }

  // ==================== Convenience Methods ====================

  /// Search products by keyword
  Future<void> searchProducts(String keyword) async {
    await fetchProducts(params: ProductQueryParams.search(keyword));
  }

  /// Filter by category
  Future<void> filterByCategory(List<int> categoryIds) async {
    await fetchProducts(params: ProductQueryParams.byCategory(categoryIds));
  }

  /// Get featured products
  Future<void> fetchFeaturedProducts() async {
    await fetchProducts(params: ProductQueryParams.featured());
  }

  /// Get best sellers
  Future<void> fetchBestSellers() async {
    await fetchProducts(params: ProductQueryParams.bestSellers());
  }

  /// Filter by price range
  Future<void> filterByPrice(double min, double max) async {
    await fetchProducts(params: ProductQueryParams.priceRange(min, max));
  }

  /// Sort products
  Future<void> sortProducts(ProductSortOption sortBy) async {
    await fetchProducts(
      params: _currentParams.copyWith(sortBy: sortBy, page: 1),
    );
  }

  /// Apply sort and update UI state
  Future<void> applySort(ProductSortOption sort) async {
    selectedSort.value = sort;
    await sortProducts(sort);
  }

  /// Apply custom filters
  Future<void> applyFilters({
    String? search,
    List<int>? categoryIds,
    double? priceMin,
    double? priceMax,
    bool? isFeatured,
    bool? isBestSeller,
    bool? inStock,
    ProductSortOption? sortBy,
  }) async {
    await fetchProducts(
      params: ProductQueryParams(
        search: search,
        categoryIds: categoryIds,
        priceMin: priceMin,
        priceMax: priceMax,
        isFeatured: isFeatured,
        isBestSeller: isBestSeller,
        inStock: inStock,
        sortBy: sortBy,
        includes: ProductIncludes.basic,
      ),
    );
  }

  /// Clear all filters and get all products
  Future<void> clearFilters() async {
    await fetchProducts(params: ProductQueryParams.all());
  }

  // ==================== Preview Sections ====================

  /// Fetch best sellers preview (10 items for horizontal section)
  Future<void> fetchBestSellersPreview() async {
    isLoadingBestSellers.value = true;

    final result = await _repo.fetchBestSellers(page: 1, perPage: 10);

    result.fold(
      (failure) {
        print('❌ Failed to fetch best sellers: ${failure.message}');
        bestSellers.clear();
      },
      (response) {
        bestSellers.value = response.items;
        print('✅ Loaded ${response.items.length} best sellers');
      },
    );

    isLoadingBestSellers.value = false;
  }

  /// Fetch new arrivals preview (10 items for horizontal section)
  Future<void> fetchNewArrivalsPreview() async {
    isLoadingNewArrivals.value = true;

    final result = await _repo.fetchNewArrivals(page: 1, perPage: 10);

    result.fold(
      (failure) {
        print('❌ Failed to fetch new arrivals: ${failure.message}');
        newArrivals.clear();
      },
      (response) {
        newArrivals.value = response.items;
        print('✅ Loaded ${response.items.length} new arrivals');
      },
    );

    isLoadingNewArrivals.value = false;
  }
}

