import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/reviews/review_model.dart';

/// Controller for All Reviews page
/// Handles paginated review loading and pull-to-refresh
class AllReviewsController extends GetxController {
  static AllReviewsController get instance => Get.find();

  // Observable state
  final reviews = <ReviewModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  // Product info
  late final int productId;
  late final String productName;
  late final int totalReviews;

  // Pagination
  int currentPage = 1;
  final int perPage = 15;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from navigation
    final args = Get.arguments as Map<String, dynamic>;
    productId = args['productId'] as int;
    productName = args['productName'] as String;
    totalReviews = args['totalReviews'] as int;

    // Load initial reviews (passed from product details)
    if (args.containsKey('initialReviews')) {
      reviews.value = args['initialReviews'] as List<ReviewModel>;
    }

    // If we have all reviews, no need to fetch more
    if (reviews.length >= totalReviews) {
      hasMore.value = false;
    }
  }

  /// Pull to refresh
  Future<void> refreshReviews() async {
    currentPage = 1;
    hasMore.value = true;
    await _fetchReviews(isRefresh: true);
  }

  /// Load more reviews (pagination)
  Future<void> loadMoreReviews() async {
    if (isLoadingMore.value || !hasMore.value) return;

    currentPage++;
    await _fetchReviews(isRefresh: false);
  }

  /// Fetch reviews from API
  Future<void> _fetchReviews({required bool isRefresh}) async {
    // TODO: Implement when Reviews API endpoint is available
    // For now, we're showing the reviews passed from product details
    // This is a placeholder for future implementation

    if (isRefresh) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      // TODO: Call ReviewRepository to fetch reviews
      // final result = await ReviewRepository.getProductReviews(
      //   productId: productId,
      //   page: currentPage,
      //   perPage: perPage,
      // );

      // result.fold(
      //   (failure) => AppToast.error(failure.message),
      //   (response) {
      //     if (isRefresh) {
      //       reviews.value = response.items;
      //     } else {
      //       reviews.addAll(response.items);
      //     }
      //     hasMore.value = reviews.length < totalReviews;
      //   },
      // );

      // For now, just mark as no more data
      await Future.delayed(const Duration(milliseconds: 500));
      hasMore.value = false;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
