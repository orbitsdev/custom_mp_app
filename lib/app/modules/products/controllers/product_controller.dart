import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
class ProductController extends GetxController {
  final ProductRepository _repo = ProductRepository();

  List<ProductModel> products = [];

  // Pagination state
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool isLoadingMore = false;

  bool get hasMore => currentPage < lastPage;

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
     isLoadingMore = false;   // <-- IMPORTANT for refresh
  currentPage = 1;  
    update();

    final result = await _repo.fetchProducts(page: 1);

    result.fold((failure) {
      products.clear();
    }, (pagination) {
      products = pagination.items;
      currentPage = pagination.currentPage;
      lastPage = pagination.lastPage;
    });

    isLoading = false;
    update();
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    update();

    final nextPage = currentPage + 1;
    final result = await _repo.fetchProducts(page: nextPage);

    result.fold((failure) {}, (pagination) {
      products.addAll(pagination.items);
      currentPage = pagination.currentPage;
    });

    isLoadingMore = false;
    update();
  }
}

