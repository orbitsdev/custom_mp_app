import 'package:custom_mp_app/app/data/models/category/category_model.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';
import 'package:custom_mp_app/app/data/models/products/product_pagination_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Category Products Controller
///
/// Handles:
/// - Products filtered by category
/// - Search within category (with debouncing)
/// - Sorting and filtering
/// - Pagination with infinite scroll
class CategoryProductsController extends GetxController {
  final ProductRepository _productRepo = ProductRepository();

  // Category info
  late final CategoryModel category;

  // Search within category
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  // Debounce helper for real-time search
  final _searchQueryDebounce = ''.obs;

  // Products state
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // Pagination
  ProductQueryParams _currentParams = ProductQueryParams.all();
  ProductPaginationResponse? _currentResponse;

  // Filters
  final selectedSort = Rxn<ProductSortOption>();

  bool get hasMore =>
      _currentResponse != null && _currentResponse!.hasNextPage;

  @override
  void onInit() {
    super.onInit();

    // Get category from arguments
    if (Get.arguments != null && Get.arguments is CategoryModel) {
      category = Get.arguments as CategoryModel;
    } else {
      // Fallback - should not happen if properly navigated
      Get.back();
      return;
    }

    // Debounce search queries (wait 500ms after user stops typing)
    debounce(
      _searchQueryDebounce,
      (_) => _performSearch(),
      time: Duration(milliseconds: 500),
    );

    // Fetch products for this category
    fetchProducts();
  }

  /// Internal method for debounced search
  void _performSearch() {
    searchQuery.value = _searchQueryDebounce.value;
    fetchProducts();
  }

  /// Fetch products for this category
  Future<void> fetchProducts() async {
    isLoading.value = true;
    products.clear();

    _currentParams = ProductQueryParams(
      categoryIds: [category.id],
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
      sortBy: selectedSort.value,
      page: 1,
      perPage: 20,
      includes: ['media', 'categories', 'variants'],
    );

    final result = await _productRepo.fetchProducts(params: _currentParams);

    result.fold(
      (error) {
        print('❌ Category products error: ${error.message}');
      },
      (response) {
        products.value = response.items;
        _currentResponse = response;
        print('✅ Found ${response.total} products in category "${category.name}"');
      },
    );

    isLoading.value = false;
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    isLoadingMore.value = true;

    final nextParams = _currentParams.copyWith(
      page: _currentParams.page + 1,
    );

    final result = await _productRepo.fetchProducts(params: nextParams);

    result.fold(
      (error) {
        print('❌ Load more error: ${error.message}');
      },
      (response) {
        products.addAll(response.items);
        _currentResponse = response;
        _currentParams = nextParams;
      },
    );

    isLoadingMore.value = false;
  }

  /// Apply sorting
  Future<void> applySort(ProductSortOption sort) async {
    selectedSort.value = sort;
    await fetchProducts();
  }

  /// Execute search within category (real-time, debounced)
  void executeSearch(String query) {
    _searchQueryDebounce.value = query.trim();
  }

  /// Clear search
  void clearSearch() {
    _searchQueryDebounce.value = '';
    searchQuery.value = '';
    fetchProducts();
  }

  /// Refresh products (pull-to-refresh)
  Future<void> refresh() async {
    await fetchProducts();
  }
}
