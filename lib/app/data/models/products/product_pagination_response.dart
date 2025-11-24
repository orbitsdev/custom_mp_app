import 'product_model.dart';

/// Product pagination response from API
///
/// Matches the actual API response structure:
/// ```json
/// {
///   "status": true,
///   "message": "Products retrieved successfully.",
///   "data": {
///     "items": [...],
///     "pagination": {
///       "current_page": 1,
///       "last_page": 3,
///       "per_page": 15,
///       "total": 34,
///       "next_page_url": "...",
///       "prev_page_url": "..."
///     }
///   }
/// }
/// ```
class ProductPaginationResponse {
  final List<ProductModel> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  ProductPaginationResponse({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.nextPageUrl,
    required this.prevPageUrl,
  });

  factory ProductPaginationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final pagination = data['pagination'];

    return ProductPaginationResponse(
      items: (data['items'] as List)
          .map((e) => ProductModel.fromMap(e))
          .toList(),
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      perPage: pagination['per_page'] ?? 15,
      total: pagination['total'] ?? 0,
      nextPageUrl: pagination['next_page_url'],
      prevPageUrl: pagination['prev_page_url'],
    );
  }

  /// Check if there's a next page available
  bool get hasNextPage => nextPageUrl != null;

  /// Check if there's a previous page available
  bool get hasPrevPage => prevPageUrl != null;

  /// Check if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Check if this is the last page
  bool get isLastPage => currentPage == lastPage;

  /// Check if there are any items
  bool get isEmpty => items.isEmpty;

  /// Check if there are items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get the total number of items across all pages
  int get totalItems => total;

  /// Get the number of items on current page
  int get itemCount => items.length;

  @override
  String toString() {
    return 'ProductPaginationResponse(page: $currentPage/$lastPage, items: ${items.length}, total: $total)';
  }
}
