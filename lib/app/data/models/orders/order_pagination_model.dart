class OrderPaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  OrderPaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory OrderPaginationModel.fromMap(Map<String, dynamic> map) {
    return OrderPaginationModel(
      currentPage: map['current_page'] ?? 1,
      lastPage: map['last_page'] ?? 1,
      perPage: map['per_page'] ?? 15,
      total: map['total'] ?? 0,
      nextPageUrl: map['next_page_url'],
      prevPageUrl: map['prev_page_url'],
    );
  }

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;
  bool get isLastPage => currentPage >= lastPage;
}
