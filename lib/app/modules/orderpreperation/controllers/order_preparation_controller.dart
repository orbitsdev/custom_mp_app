import 'package:custom_mp_app/app/data/models/orderpreparation/order_preparation_model.dart';
import 'package:custom_mp_app/app/data/repositories/order_preparation_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
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
  }

  // -------------------------------------------------------------
  // FETCH API
  // -------------------------------------------------------------
  Future<void> fetchOrderPreparation({int? packageId}) async {
    isLoading.value = true;

    final result = await _prepRepo.fetchOrderPreparation(packageId: packageId);

    result.fold(
      (failure) {
        AppToast.error(failure.message);
        isLoading.value = false;
        print('❌ Fetch failed: ${failure.message}');
      },
      (data) {
        print('__________ahelwe');
        print(data);
        print('__________yow');
            isLoading.value = false;
        orderPreparation.value = data;
        // print('_____________YOOO0000W');
        // print(orderPreparation.value.toString());
        // print('_____________YOOO0000000000W');
        AppToast.success('sucues');
        selectedPackageId.value = data.selectedPackageId;
        isLoading.value = false;

        if (data.shippingAddresses.isNotEmpty) {
          selectedAddressId.value =
              data.shippingAddresses.firstWhereOrNull((e) => e.isDefault as bool)?.id ??
              data.shippingAddresses.first.id;
        }
      },
    );
  }

  // -------------------------------------------------------------
  // CHANGE PACKAGE
  // -------------------------------------------------------------
  void selectPackage(int id) {
    selectedPackageId.value = id;

    // Refresh summary by requesting package_id
    fetchOrderPreparation(packageId: id);
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
