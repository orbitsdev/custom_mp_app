import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';

/// Professional Search Controller
///
/// Handles:
/// - Search history (persistent)
/// - Search suggestions
/// - Instant search results (as you type)
/// - Debouncing for performance
class ProductSearchController extends GetxController {
  static ProductSearchController get instance => Get.find();

  final ProductRepository _productRepo = ProductRepository();
  final _storage = GetStorage();

  // Search state
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  // Instant search results (Stage 1)
  final instantResults = <ProductModel>[].obs;
  final isLoadingInstant = false.obs;

  // Search history
  final searchHistory = <String>[].obs;
  static const _historyKey = 'search_history';
  static const _maxHistoryItems = 10;

  // Popular products (instead of text suggestions)
  final popularProducts = <ProductModel>[].obs;
  final isLoadingPopular = false.obs;

  @override
  void onInit() {
    super.onInit();

    // GetX debounce - cleaner than manual Timer
    debounce(
      searchQuery,
      (value) => _performInstantSearch(value.trim()),
      time: Duration(milliseconds: 500),
    );

    _loadSearchHistory();
    _loadSuggestions();
  }

  /// Called when user types in search field
  /// GetX debounce automatically handles the delay
  void onSearchChanged(String query) {
    searchQuery.value = query.trim();

    if (query.trim().isEmpty) {
      instantResults.clear();
      isLoadingInstant.value = false;
    } else {
      isLoadingInstant.value = true;
    }
  }

  /// Perform instant search (Stage 1 - as you type)
  Future<void> _performInstantSearch(String query) async {
    if (query.isEmpty) {
      instantResults.clear();
      isLoadingInstant.value = false;
      return;
    }

    isLoadingInstant.value = true;

    final result = await _productRepo.searchProducts(
      query,
      perPage: 10, // Limit instant results
    );

    result.fold(
      (error) {
        print('❌ Instant search error: ${error.message}');
        instantResults.clear();
      },
      (response) {
        instantResults.value = response.items;
        print('🔍 Instant search: Found ${response.items.length} results for "$query"');
      },
    );

    isLoadingInstant.value = false;
  }

  /// Execute full search (Stage 2 - navigate to results page)
  void executeSearch(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return;

    // Save to history
    _saveToHistory(trimmedQuery);

    // Navigate to results page
    Get.toNamed(
      Routes.searchResultsPage,
      arguments: {'query': trimmedQuery},
    );
  }

  /// Save search query to history
  void _saveToHistory(String query) {
    if (query.isEmpty) return;

    // Remove if already exists (to move to top)
    searchHistory.remove(query);

    // Add to beginning
    searchHistory.insert(0, query);

    // Limit history size
    if (searchHistory.length > _maxHistoryItems) {
      searchHistory.removeRange(_maxHistoryItems, searchHistory.length);
    }

    // Persist to storage
    _storage.write(_historyKey, searchHistory.toList());
  }

  /// Load search history from storage
  void _loadSearchHistory() {
    final history = _storage.read<List>(_historyKey);
    if (history != null) {
      searchHistory.value = history.cast<String>();
    }
  }

  /// Clear search history
  void clearHistory() {
    searchHistory.clear();
    _storage.remove(_historyKey);
  }

  /// Remove single history item
  void removeHistoryItem(String query) {
    searchHistory.remove(query);
    _storage.write(_historyKey, searchHistory.toList());
  }

  /// Load popular products for suggestions
  Future<void> _loadSuggestions() async {
    isLoadingPopular.value = true;

    // Fetch featured/best-selling products
    final result = await _productRepo.fetchFeaturedProducts(perPage: 10);

    result.fold(
      (error) {
        print('❌ Failed to load popular products: ${error.message}');
        popularProducts.clear();
      },
      (response) {
        popularProducts.value = response.items;
        print('✅ Loaded ${response.items.length} popular products');
      },
    );

    isLoadingPopular.value = false;
  }

  /// Clear search input
  void clearSearch() {
    searchQuery.value = '';
    instantResults.clear();
    isLoadingInstant.value = false;
  }
}
