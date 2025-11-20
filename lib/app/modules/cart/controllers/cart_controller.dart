import 'package:custom_mp_app/app/data/models/cart/cart_debounce_handler.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_select_all_handler.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_summary_model.dart';
import 'package:custom_mp_app/app/data/repositories/cart_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  final CartRepository _cartRepo = CartRepository();
  final carts = <CartItemModel>[].obs;
  final isLoading = false.obs;
  final cartSummary = CartSummaryModel().obs;

  /// ⭐ SINGLE debounce handler for ALL cart actions
  final isSummaryUpdating = false.obs;
  final cartDebounceHandler = CartDebounceHandler().obs;
 final selectAllHandler = CartSelectAllHandler().obs;
 final selectAllValue = false.obs;   // <-- REAL checkbox state

  int get selectedRowCount => carts.where((e) => e.isSelected == true).length;

  bool get hasSelectedItems => selectedRowCount > 0;
 @override
void onInit() {
  super.onInit();

  // Quantity / toggle worker
  debounce(
    cartDebounceHandler,
    (handler) {
      if (handler.action == null || handler.item == null) return;
      handleAction(handler);
    },
    time: const Duration(milliseconds: 300),
  );

  // Select-All worker
 debounce<CartSelectAllHandler>(
  selectAllHandler,
  (handler) {
    if (handler.selectAll == null) return;
    toggleSelectAll(handler.selectAll!);
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
    _updateLocalQuantity(item, 1); // correct indentation
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
     isSummaryUpdating.value = true;
    final result = await _cartRepo.removeItem(item.id!);

    result.fold(
      (failure) {
        // ❌ API failed → revert UI
        carts.insert(index, oldItem);
        AppToast.error(failure.message);
         isSummaryUpdating.value = false;
      },
      (_) async {
        AppModal.success(message: "Item deleted successfully");
        print("✔ Cart item deleted successfully");
           await fetchCartSummary();  
         isSummaryUpdating.value = false;
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
  final newValue = !(current.isSelected ?? false);

  // 1️⃣ Update the item
  carts[index] = current.copyWith(isSelected: newValue);

  // 2️⃣ Auto-update select-all state
  final allSelected = carts.every((e) => e.isSelected == true);
  final noneSelected = carts.every((e) => e.isSelected == false);

  if (allSelected) {
    selectAllValue.value = true;
  } else if (noneSelected) {
    selectAllValue.value = false;
  } else {
    // Mixed state — uncheck "select all"
    selectAllValue.value = false;
  }
}


   void uiToggleSelectAll(bool value) {
  selectAllValue.value = value;
  carts.value = carts.map((e) => e.copyWith(isSelected: value)).toList();
  selectAllHandler.value = CartSelectAllHandler(selectAll: value);
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
 isSummaryUpdating.value = true;
    final result = await _cartRepo.updateQuantity(
      cartItemId: newItem.id!,
      quantity: newItem.quantity!,
    );

    result.fold(
      (failure) {
        carts[index] = oldItem; // 🔥 revert
        AppToast.error(failure.message);
         isSummaryUpdating.value = false;
      },
      (_) async {
         await fetchCartSummary();  
        isSummaryUpdating.value = false;
        print('qadd quanity success'); 
      },
    );
  }

  Future<void> removeQuantity(CartItemModel originalItem) async {
    print("➡ Backend sync: remove qty for item ${originalItem.id}");

    final index = carts.indexWhere((e) => e.id == originalItem.id);
    if (index == -1) return;

    final newItem = carts[index];
    final oldItem = originalItem;

    // Prevent negative quantity (UI already prevents it)
    if ((newItem.quantity ?? 1) < 1) return;
     isSummaryUpdating.value = true;
    final result = await _cartRepo.updateQuantity(
      cartItemId: newItem.id!,
      quantity: newItem.quantity!,
    );

    result.fold(
      (failure) {
        carts[index] = oldItem;
        AppToast.error(failure.message);
         isSummaryUpdating.value = false;
      },
      (_) async {
        print('decemenent success');
          await fetchCartSummary();
           isSummaryUpdating.value = false;
      },
    );
  }

  Future<void> toggleSelect(CartItemModel originalItem) async {
    print("➡ Backend sync: toggle select for item ${originalItem.id}");

    final index = carts.indexWhere((e) => e.id == originalItem.id);
    if (index == -1) return;

    final newItem = carts[index];
    final oldItem = originalItem;
   isSummaryUpdating.value = true;
    final result = await _cartRepo.updateSelection(
      cartItemId: newItem.id!,
      isSelected: newItem.isSelected!,
    );

    result.fold((failure) {
      carts[index] = oldItem; // 🔥 revert
      AppToast.error(failure.message);
       isSummaryUpdating.value = false;
    }, (_)  async {
          await fetchCartSummary();
           isSummaryUpdating.value = false;
    });
  }



Future<void> toggleSelectAll(bool value) async {
   isSummaryUpdating.value = true;
  final result = await _cartRepo.selectAll(isSelected: value);

  result.fold(
    (failure) {
   
      carts.value = carts.map((e) => e.copyWith(isSelected: !value)).toList();
      selectAllValue.value = !value;
      AppToast.error(failure.message);
       isSummaryUpdating.value = false;
    },
    (_)  async {
      print("✔ Select-all updated");
        await fetchCartSummary();
         isSummaryUpdating.value = false;
    },
  );
}





Future<void> fetchCartSummary() async {

  
  final response = await _cartRepo.fetchCartSummary();

  response.fold(
    (failure) => AppToast.error(failure.message),
    (data) {
      cartSummary.value = data;
      print("Updated summary: $cartSummary");
    },
  );
}


}
