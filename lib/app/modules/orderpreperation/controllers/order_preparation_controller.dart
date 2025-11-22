import 'package:custom_mp_app/app/data/models/orderpreparation/order_preparation_model.dart';
import 'package:custom_mp_app/app/data/repositories/order_preparation_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/controllers/shipping_address_controller.dart';
import 'package:get/get.dart';

class OrderPreparationController extends GetxController {
  static OrderPreparationController get instance => Get.find();

  final OrderPreparationRepository _prepRepo = OrderPreparationRepository();

  final isLoading = false.obs;
  final isPlacingOrder = false.obs;

  final orderPreparation = Rxn<OrderPreparationModel>();

  /// Selected Package (nullable)
  final selectedPackageId = Rxn<int>();

  /// Selected Shipping Address (nullable)
  final selectedAddressId = Rxn<int>();

  // -------------------------------------------------------------
  // INIT
  // -------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    final sa = Get.find<ShippingAddressController>();

    // 🔥 Listen only to default address changes
    ever(sa.addresses, (_) {
      'EVER WAS CALLLED';
      updateSelectedAddressFromGlobalList();
    });
  }

  void updateSelectedAddressFromGlobalList() {
    final current = orderPreparation.value;
    if (current == null) return;

    final sa = Get.find<ShippingAddressController>();
    if (sa.addresses.isEmpty) return;

    final defaultAddr = sa.addresses.firstWhereOrNull((e) => e.isDefault);

    selectedAddressId.value = defaultAddr?.id;
  }

  // -------------------------------------------------------------
  // FETCH API
  // -------------------------------------------------------------
  Future<void> fetchOrderPreparation({int? packageId}) async {
    isLoading.value = true;

    final result = await _prepRepo.fetchOrderPreparation(packageId: packageId);

    result.fold(
      (failure) {
        isLoading.value = false;
        AppToast.error(failure.message);

        if (failure.dioException?.response?.statusCode == 404) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (Get.isOverlaysOpen) Get.back();
            Get.b
            ack();
          });
        }
      },
      (data) {
        isLoading.value = false;

        orderPreparation.value = data;

        selectedPackageId.value = data.selectedPackageId;

        // ⭐ CRITICAL FIX
        selectedAddressId.value = data.selectedShippingAddressId;
      },
    );
  }

  void selectPackage(int id) {
    // If same package tapped → unselect
    if (selectedPackageId.value == id) {
      selectedPackageId.value = null;

      final prep = orderPreparation.value!;

      // Reset summary (remove packagingFee)
      final newSummary = prep.summary.copyWith(
        packagingFee: 0,
        total: prep.summary.subtotal,
      );

      orderPreparation.value = prep.copyWith(
        summary: newSummary,
        selectedPackageId: null,
      );

      print("UNSELECTED package");
      return;
    }

    // Normal selection
    selectedPackageId.value = id;

    final prep = orderPreparation.value!;
    final selected = prep.packages.firstWhere((p) => p.id == id);

    final newSummary = prep.summary.copyWith(
      packagingFee: selected.price,
      total: prep.summary.subtotal + selected.price,
    );

    orderPreparation.value = prep.copyWith(
      summary: newSummary,
      selectedPackageId: id,
    );

    print("SELECTED package: $id");
  }

  // -------------------------------------------------------------
  // CHANGE SHIPPING ADDRESS
  // -------------------------------------------------------------
  void selectAddress(int id) {
    selectedAddressId.value = id;
  }

  // -------------------------------------------------------------
  // PLACE ORDER
  // (You will fill this later)
  // -------------------------------------------------------------
  Future<void> placeOrder() async {
    if (selectedAddressId.value == null) {
      print("❌ No address selected");
      return;
    }

    isPlacingOrder.value = true;

    // TODO: call your API /orders here
    await Future.delayed(Duration(seconds: 2));

    isPlacingOrder.value = false;
  }
}
