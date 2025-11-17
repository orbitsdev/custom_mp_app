import 'product_model.dart';

class ProductPaginationResponse {
  final List<ProductModel> items;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;

  ProductPaginationResponse({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
  });

  factory ProductPaginationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ProductPaginationResponse(
      items: (data['items'] as List)
          .map((e) => ProductModel.fromMap(e))
          .toList(),
      currentPage: data['pagination']['current_page'] ?? 1,
      lastPage: data['pagination']['last_page'] ?? 1,
      nextPageUrl: data['pagination']['next_page_url'],
    );
  }
}
