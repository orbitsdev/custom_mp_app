import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';
import 'package:custom_mp_app/app/data/models/products/product_pagination_response.dart';

/// Search Results Controller (Stage 2)
///
/// Handles:
/// - Full search results with pagination
/// - Filtering and sorting
/// - Load more functionality
class SearchResultsController extends GetxController {
  final ProductRepository _productRepo = ProductRepository();

  // Search query (observable for reactive UI)
  final searchQuery = ''.obs;

  // Results
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

    // Get search query from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      searchQuery.value = Get.arguments['query'] ?? '';
    }

    if (searchQuery.value.isNotEmpty) {
      searchProducts();
    }
  }

  /// Search products
  Future<void> searchProducts() async {
    isLoading.value = true;
    products.clear();

    _currentParams = ProductQueryParams(
      search: searchQuery.value,
      sortBy: selectedSort.value,
      page: 1,
      perPage: 20,
      includes: ['media', 'categories', 'variants'],
    );

    final result = await _productRepo.fetchProducts(params: _currentParams);

    result.fold(
      (error) {
        print('❌ Search error: ${error.message}');
      },
      (response) {
        products.value = response.items;
        _currentResponse = response;
        print('✅ Found ${response.total} products for "${searchQuery.value}"');
      },
    );

    isLoading.value = false;
  }

  /// Load more results
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
    await searchProducts();
  }

  /// Refresh results
  Future<void> refresh() async {
    await searchProducts();
  }
}
