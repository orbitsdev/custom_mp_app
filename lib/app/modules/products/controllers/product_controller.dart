import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';

class ProductController extends GetxController {
  final ProductRepository _repo = ProductRepository();

  final isLoading = false.obs;
  final products = <ProductModel>[].obs;

  @override
  void onReady() {
    super.onReady();

    fetchProducts();
    print('ONREADY______CALLED');
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;

    final result = await _repo.fetchProducts();

    result.fold(
      (failure) {
        print('❌ Product fetch failed: ${failure.message}');
        AppToast.error('Failed: ${failure.message}');
        products.clear();
      },
      (data) {
        products.assignAll(data);
        print('✅ Loaded ${data.length} products');
      },
    );

    isLoading.value = false;
  }
}
