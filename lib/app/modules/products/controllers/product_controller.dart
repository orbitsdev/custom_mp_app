import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';

class ProductController extends GetxController {
  final ProductRepository _repo = ProductRepository();

  bool isLoading = false;
  List<ProductModel> products = [];

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
    print('ONREADY______CALLED');
  }

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      update(); // 🔹 trigger UI rebuild (shows loading state)

      final result = await _repo.fetchProducts();

      result.fold(
        (failure) {
          print('❌ ${failure.message}');
          AppToast.error('Product fetch failed: ${failure.message}');
          products.clear();
        },
        (data) {
          products = data;
          print('✅ Loaded ${data.length} products');
        },
      );

      isLoading = false;
      update(); // 🔹 rebuild again after success/failure
    } catch (e) {
      isLoading = false;
      update();
      print('❌ Unexpected error: $e');
    }
  }
}
