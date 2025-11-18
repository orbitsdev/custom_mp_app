import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/data/repositories/cart_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  final CartRepository _cartRepo = CartRepository();
  final carts = <CartItemModel>[].obs;
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchCart();
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    final result = await _cartRepo.fetchCart();

    result.fold(
      (failure) => AppToast.error(failure.message),
      (data) => carts.assignAll(data),
    );

    isLoading.value = false;
  }

  /// ✔ Number of selected rows
  int get selectedRowCount =>
      carts.where((e) => e.isSelected).length;

  /// ✔ Show checkout section?
  bool get hasSelectedItems => selectedRowCount > 0;
}
