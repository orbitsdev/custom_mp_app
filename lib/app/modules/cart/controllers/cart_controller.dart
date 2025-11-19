import 'package:custom_mp_app/app/data/models/cart/cart_debounce_handler.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/data/repositories/cart_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  final CartRepository _cartRepo = CartRepository();
  final carts = <CartItemModel>[].obs;
  final isLoading = false.obs;

  /// ⭐ SINGLE debounce handler for ALL cart actions
  final cartDebounceHandler = CartDebounceHandler().obs;

  @override
  void onInit() {
    super.onInit();

    /// ⭐ Debounce ONLY triggers backend sync, not UI updates
    debounce<CartDebounceHandler>(
      cartDebounceHandler,
      (handler) {
        if (handler.action == null || handler.item == null) return;
        handleAction(handler); // backend-sync only
      },
      time: const Duration(milliseconds: 300),
    );
  }

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

  // ----------------------------------------------------------------------
  // ACTION DISPATCHER
  // ----------------------------------------------------------------------

  void handleAction(CartDebounceHandler handler) {
    switch (handler.action) {
      case CartDebounceHandler.addQuantity:
        addQuantity(handler.item!);
        break;

      case CartDebounceHandler.removeQuantity:
        removeQuantity(handler.item!);
        break;

      case CartDebounceHandler.toggleSelect:
        toggleSelect(handler.item!);
        break;
    }
  }

  // ----------------------------------------------------------------------
  // UI TRIGGERS (UI → local update → debounce backend)
  // ----------------------------------------------------------------------

  void uiAddQty(CartItemModel item) {
  _updateLocalQuantity(item, 1);  // correct indentation
    cartDebounceHandler.value = CartDebounceHandler(
      item: item,
      action: CartDebounceHandler.addQuantity,
    );
  }

  void uiRemoveQty(CartItemModel item) {
    _updateLocalQuantity(item, -1); // ⭐ UI updates immediately
    cartDebounceHandler.value = CartDebounceHandler(
      item: item,
      action: CartDebounceHandler.removeQuantity,
    );
  }

  void uiToggleSelect(CartItemModel item) {
    _toggleLocalSelect(item); // ⭐ UI updates immediately
    cartDebounceHandler.value = CartDebounceHandler(
      item: item,
      action: CartDebounceHandler.toggleSelect,
    );
  }

  // ⭐ UI Delete Action (instant remove + backend sync)
void uiDeleteItem(CartItemModel item) async {
  final index = carts.indexWhere((e) => e.id == item.id);
  if (index == -1) return;

  final oldItem = carts[index];

  // 🔥 Optimistic UI — remove now
  carts.removeAt(index);

  // 🔥 Call Backend
  final result = await _cartRepo.removeItem(item.id!);

  result.fold(
    (failure) {
      // ❌ API failed → revert UI
      carts.insert(index, oldItem);
      AppToast.error(failure.message);
    },
    (_) {
      AppModal.success(message: "Item deleted successfully");
      print("✔ Cart item deleted successfully");
    },
  );
}


  // ----------------------------------------------------------------------
  // ⭐ LOCAL UI UPDATES (Optimistic UI)
  // ----------------------------------------------------------------------

  void _updateLocalQuantity(CartItemModel item, int change) {
    final index = carts.indexWhere((e) => e.id == item.id);
    if (index == -1) return;

    final current = carts[index];
    final newQty = (current.quantity ?? 1) + change;

    if (newQty < 1) return; // prevent 0 quantity

    carts[index] = current.copyWith(quantity: newQty);
  }

  void _toggleLocalSelect(CartItemModel item) {
    final index = carts.indexWhere((e) => e.id == item.id);
    if (index == -1) return;

    final current = carts[index];
    carts[index] = current.copyWith(
      isSelected: !(current.isSelected ?? false),
    );
  }

  // ----------------------------------------------------------------------
  // ⭐ BACKEND SYNC ACTIONS (debounced)
  // ----------------------------------------------------------------------

  Future<void> addQuantity(CartItemModel originalItem) async {
    print("➡ Backend sync: add qty for item ${originalItem.id}");

    final index = carts.indexWhere((e) => e.id == originalItem.id);
    if (index == -1) return;

    final newItem = carts[index]; // updated by UI
    final oldItem = originalItem; // old version before UI changes

    // ─── Call API ───────────────────────────────────────────
    // final result = await _cartRepo.updateQuantity(
    //   itemId: newItem.id!,
    //   quantity: newItem.quantity!,
    // );

    // result.fold(
    //   (failure) {
    //     carts[index] = oldItem; // 🔥 revert
    //     AppToast.error(failure.message);
    //   },
    //   (_) {
    //     print("Backend quantity updated successfully.");
    //   },
    // );
  }

  Future<void> removeQuantity(CartItemModel originalItem) async {
    print("➡ Backend sync: remove qty for item ${originalItem.id}");

    final index = carts.indexWhere((e) => e.id == originalItem.id);
    if (index == -1) return;

    final newItem = carts[index];
    final oldItem = originalItem;

    // Prevent negative quantity (UI already prevents it)
    if ((newItem.quantity ?? 1) < 1) return;

    // final result = await _cartRepo.updateQuantity(
    //   itemId: newItem.id!,
    //   quantity: newItem.quantity!,
    // );

    // result.fold(
    //   (failure) {
    //     carts[index] = oldItem;
    //     AppToast.error(failure.message);
    //   },
    //   (_) => print("Backend remove quantity updated."),
    // );
  }

  Future<void> toggleSelect(CartItemModel originalItem) async {
    print("➡ Backend sync: toggle select for item ${originalItem.id}");

    final index = carts.indexWhere((e) => e.id == originalItem.id);
    if (index == -1) return;

    final newItem = carts[index];
    final oldItem = originalItem;

    // final result = await _cartRepo.toggleSelect(
    //   itemId: newItem.id!,
    //   isSelected: newItem.isSelected!,
    // );

    // result.fold(
    //   (failure) {
    //     carts[index] = oldItem; // 🔥 revert
    //     AppToast.error(failure.message);
    //   },
    //   (_) => print("Backend selection updated."),
    // );
  }


  
  // ----------------------------------------------------------------------
  // GETTERS
  // ----------------------------------------------------------------------

  int get selectedRowCount =>
      carts.where((e) => e.isSelected == true).length;

  bool get hasSelectedItems => selectedRowCount > 0;
}
