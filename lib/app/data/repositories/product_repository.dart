import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/models/products/product_pagination_response.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';

/// Flexible Product Repository matching backend API capabilities
///
/// This repository supports all Product API features including:
/// - Flexible filtering (search, category, price, status)
/// - Multiple sorting options
/// - Pagination with configurable page size
/// - Dynamic relation loading (includes)
/// - Search + Price combination (Bug #2 fixed in backend)
///
/// Example usage:
/// ```dart
/// // Simple: Get all products
/// final result = await productRepo.fetchProducts();
///
/// // Search products
/// final result = await productRepo.fetchProducts(
///   params: ProductQueryParams.search('coconut'),
/// );
///
/// // Filter by category
/// final result = await productRepo.fetchProducts(
///   params: ProductQueryParams.byCategory([1, 2]),
/// );
///
/// // Complex query with multiple filters
/// final result = await productRepo.fetchProducts(
///   params: ProductQueryParams(
///     search: 'coffee',
///     categoryIds: [1],
///     priceMin: 10,
///     priceMax: 50,
///     isFeatured: true,
///     inStock: true,
///     sortBy: ProductSortOption.priceLowToHigh,
///     page: 1,
///     perPage: 20,
///   ),
/// );
/// ```
class ProductRepository {

  /// Fetch products with flexible filtering, sorting, and pagination
  ///
  /// Returns paginated list of products matching the query parameters.
  /// All parameters are optional - defaults to fetching all products.
  ///
  /// **Parameters:**
  /// - [params] - Query parameters (filters, sort, pagination)
  ///
  /// **Supported Filters:**
  /// - Search: `search: 'keyword'`
  /// - Category: `categoryIds: [1, 2]`
  /// - Price range: `priceMin: 10, priceMax: 50`
  /// - Featured: `isFeatured: true`
  /// - Best seller: `isBestSeller: true`
  /// - New arrival: `isNewArrival: true`
  /// - In stock: `inStock: true`
  ///
  /// **Sorting:**
  /// - `sortBy: ProductSortOption.priceLowToHigh`
  /// - `sortBy: ProductSortOption.newest`
  /// - `sortBy: ProductSortOption.mostPopular`
  /// - See [ProductSortOption] for all options
  ///
  /// **Examples:**
  /// ```dart
  /// // Get featured products
  /// fetchProducts(params: ProductQueryParams.featured());
  ///
  /// // Search with price filter (works since Bug #2 fixed!)
  /// fetchProducts(params: ProductQueryParams(
  ///   search: 'coconut',
  ///   priceMin: 50,
  ///   priceMax: 100,
  /// ));
  ///
  /// // Load next page
  /// fetchProducts(params: params.copyWith(page: 2));
  /// ```
  EitherModel<ProductPaginationResponse> fetchProducts({
    ProductQueryParams? params,
  }) async {
    try {
      final dio = await DioClient.auth;

      // Use default params if none provided
      final queryParams = params ?? ProductQueryParams.all();

      print('🔍 Fetching products: $queryParams');

      final response = await dio.get(
        'products',
        queryParameters: queryParams.toQueryParameters(),
      );

      final parsed = ProductPaginationResponse.fromJson(response.data);

      print('📦 Page ${queryParams.page} loaded: ${parsed.items.length} products');

      return right(parsed);
    } on DioException catch (e) {
      // Handle specific API errors
      if (e.response?.statusCode == 422) {
        // Validation error (e.g., negative price)
        return left(FailureModel.fromDio(e));
      } else if (e.response?.statusCode == 400) {
        // Invalid parameters (e.g., invalid sort field)
        return left(FailureModel.fromDio(e));
      }
      return left(FailureModel.fromDio(e));
    } on ArgumentError catch (e) {
      // Client-side validation error
      return left(FailureModel.manual(e.message));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Fetch all products (simple helper method)
  ///
  /// Convenience method for fetching all products with default settings.
  /// Includes media, categories, and variants by default.
  ///
  /// **Parameters:**
  /// - [page] - Page number (default: 1)
  /// - [perPage] - Items per page (default: 15)
  ///
  /// **Example:**
  /// ```dart
  /// final result = await productRepo.fetchAllProducts(page: 2);
  /// ```
  EitherModel<ProductPaginationResponse> fetchAllProducts({
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams.all(page: page, perPage: perPage),
    );
  }

  /// Search products by keyword
  ///
  /// Searches across product name, description, and short_description.
  ///
  /// **Parameters:**
  /// - [keyword] - Search term
  /// - [page] - Page number (default: 1)
  /// - [perPage] - Items per page (default: 15)
  ///
  /// **Example:**
  /// ```dart
  /// final result = await productRepo.searchProducts('coconut');
  /// ```
  EitherModel<ProductPaginationResponse> searchProducts(
    String keyword, {
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams.search(
        keyword,
        page: page,
        perPage: perPage,
      ),
    );
  }

  /// Fetch products by category
  ///
  /// Returns products belonging to specified category/categories.
  ///
  /// **Parameters:**
  /// - [categoryIds] - List of category IDs
  /// - [page] - Page number (default: 1)
  /// - [perPage] - Items per page (default: 15)
  ///
  /// **Examples:**
  /// ```dart
  /// // Single category
  /// fetchProductsByCategory([1]);
  ///
  /// // Multiple categories
  /// fetchProductsByCategory([1, 2, 3]);
  /// ```
  EitherModel<ProductPaginationResponse> fetchProductsByCategory(
    List<int> categoryIds, {
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams.byCategory(
        categoryIds,
        page: page,
        perPage: perPage,
      ),
    );
  }

  /// Fetch featured products
  ///
  /// Returns products marked as featured, sorted by newest.
  ///
  /// **Example:**
  /// ```dart
  /// final result = await productRepo.fetchFeaturedProducts();
  /// ```
  EitherModel<ProductPaginationResponse> fetchFeaturedProducts({
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams.featured(page: page, perPage: perPage),
    );
  }

  /// Fetch best seller products
  ///
  /// Returns products marked as best sellers, sorted by most sold.
  ///
  /// **Example:**
  /// ```dart
  /// final result = await productRepo.fetchBestSellers();
  /// ```
  EitherModel<ProductPaginationResponse> fetchBestSellers({
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams.bestSellers(page: page, perPage: perPage),
    );
  }

  /// Fetch new arrival products
  ///
  /// Returns products marked as new arrivals, sorted by newest.
  ///
  /// **Example:**
  /// ```dart
  /// final result = await productRepo.fetchNewArrivals();
  /// ```
  EitherModel<ProductPaginationResponse> fetchNewArrivals({
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams.newArrivals(page: page, perPage: perPage),
    );
  }

  /// Fetch products within price range
  ///
  /// Returns products with variants in the specified price range.
  ///
  /// **Parameters:**
  /// - [min] - Minimum price (must be >= 0)
  /// - [max] - Maximum price (must be >= 0)
  ///
  /// **Example:**
  /// ```dart
  /// // Products between ₱50 and ₱100
  /// final result = await productRepo.fetchProductsByPriceRange(50, 100);
  /// ```
  ///
  /// **Note:** API validates that prices are non-negative (Bug #3 fixed)
  EitherModel<ProductPaginationResponse> fetchProductsByPriceRange(
    double min,
    double max, {
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams.priceRange(
        min,
        max,
        page: page,
        perPage: perPage,
      ),
    );
  }

  /// Advanced search with multiple filters
  ///
  /// Combines search with price range, category, and other filters.
  /// This works correctly since Bug #2 was fixed in the backend.
  ///
  /// **Parameters:**
  /// - [keyword] - Search term
  /// - [categoryIds] - Filter by categories
  /// - [priceMin] - Minimum price
  /// - [priceMax] - Maximum price
  /// - [isFeatured] - Filter featured products
  /// - [isBestSeller] - Filter best sellers
  /// - [inStock] - Filter in-stock products only
  /// - [sortBy] - Sorting option
  ///
  /// **Example:**
  /// ```dart
  /// // Search "coffee" in category 1, price ₱10-₱30, in stock, sorted by price
  /// final result = await productRepo.advancedSearch(
  ///   keyword: 'coffee',
  ///   categoryIds: [1],
  ///   priceMin: 10,
  ///   priceMax: 30,
  ///   inStock: true,
  ///   sortBy: ProductSortOption.priceLowToHigh,
  /// );
  /// ```
  EitherModel<ProductPaginationResponse> advancedSearch({
    String? keyword,
    List<int>? categoryIds,
    double? priceMin,
    double? priceMax,
    bool? isFeatured,
    bool? isBestSeller,
    bool? inStock,
    ProductSortOption? sortBy,
    int page = 1,
    int perPage = 15,
  }) {
    return fetchProducts(
      params: ProductQueryParams(
        search: keyword,
        categoryIds: categoryIds,
        priceMin: priceMin,
        priceMax: priceMax,
        isFeatured: isFeatured,
        isBestSeller: isBestSeller,
        inStock: inStock,
        sortBy: sortBy,
        page: page,
        perPage: perPage,
        includes: ProductIncludes.basic,
      ),
    );
  }

  /// Fetch product by slug with full details
  ///
  /// Returns detailed information about a specific product.
  /// Includes all relations: variants, media, categories, attributes.
  ///
  /// **Parameters:**
  /// - [slug] - Product slug (e.g., 'fresh-young-coconut')
  ///
  /// **Example:**
  /// ```dart
  /// final result = await productRepo.fetchProductBySlug('fresh-young-coconut');
  /// ```
  EitherModel<ProductModel> fetchProductBySlug(String slug) async {
    try {
      final dio = await DioClient.auth;

      print('🔍 Fetching product: $slug');

      final response = await dio.get(
        'products/$slug',
        queryParameters: {
          'include': ProductIncludes.full.join(','),
        },
      );

      final product = ProductModel.fromMap(response.data['data']);

      print('✅ Product loaded: ${product.name}');

      return right(product);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return left(FailureModel.manual('Product not found'));
      }
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Load next page of products
  ///
  /// Helper method to load the next page using the same query parameters.
  ///
  /// **Parameters:**
  /// - [currentParams] - Current query parameters
  /// - [currentResponse] - Current pagination response
  ///
  /// **Returns:** `null` if no next page available
  ///
  /// **Example:**
  /// ```dart
  /// // Load first page
  /// final result = await repo.fetchProducts(params: params);
  ///
  /// result.fold(
  ///   (error) => print(error),
  ///   (response) async {
  ///     print('Page 1: ${response.items.length} items');
  ///
  ///     // Load next page
  ///     final nextResult = await repo.loadNextPage(params, response);
  ///     if (nextResult != null) {
  ///       nextResult.fold(
  ///         (error) => print(error),
  ///         (nextResponse) => print('Page 2: ${nextResponse.items.length} items'),
  ///       );
  ///     }
  ///   },
  /// );
  /// ```
  Future<EitherModel<ProductPaginationResponse>?> loadNextPage(
    ProductQueryParams currentParams,
    ProductPaginationResponse currentResponse,
  ) async {
    if (!currentResponse.hasNextPage) {
      print('📭 No more pages available');
      return null;
    }

    return fetchProducts(
      params: currentParams.copyWith(page: currentParams.page + 1),
    );
  }
}
