import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/data/repositories/order_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:get/get.dart';

/// Controller for Order Detail Page
/// Supports deep linking and notification navigation
/// Pattern matches SelectProductController:
/// - Accept OrderModel (from list)
/// - Accept int ID (from notification/deep link)
/// - Fetch from API if not in cache
class OrderDetailController extends GetxController {
  static OrderDetailController get to => Get.find();

  final OrderRepository _orderRepository = OrderRepository();
  final selectedOrder = Rxn<OrderModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;

    if (arg == null) {
      print('⚠️ No order argument provided');
      return;
    }

    // Pattern A: Full OrderModel (from order list - existing behavior)
    if (arg is OrderModel) {
      selectedOrder.value = arg;
      print('✅ Order loaded from argument: ${arg.orderReferenceId}');
      return;
    }

    // Pattern B: Order ID (from notification - new behavior)
    if (arg is int) {
      print('🔍 Loading order by ID: $arg');
      _loadOrderById(arg);
      return;
    }

    // Pattern C: Order ID as String (from some notifications)
    if (arg is String) {
      final orderId = int.tryParse(arg);
      if (orderId != null) {
        print('🔍 Loading order by ID (string): $orderId');
        _loadOrderById(orderId);
        return;
      }
    }

    print('⚠️ Unknown argument type: ${arg.runtimeType}');
  }

  /// Load order by ID - First try cache, then fetch from API
  /// This matches the ProductController pattern exactly
  Future<void> _loadOrderById(int orderId) async {
    isLoading.value = true;

    try {
      // Try to find order in OrdersController cache first
      final cachedOrder = _findOrderInCache(orderId);

      if (cachedOrder != null) {
        print('✅ Found order in cache: ${cachedOrder.orderReferenceId}');
        selectedOrder.value = cachedOrder;
        isLoading.value = false;
        return;
      }

      // Not in cache, fetch from API (like ProductController does)
      print('🌐 Fetching order from API: $orderId');
      final result = await _orderRepository.fetchOrderById(orderId);

      isLoading.value = false;

      result.fold(
        (failure) {
          print('❌ Failed to load order: ${failure.message}');
          AppToast.error('Failed to load order details');
        },
        (order) {
          selectedOrder.value = order;
          print('✅ Order loaded from API: ${order.orderReferenceId}');
        },
      );
    } catch (e) {
      print('❌ Error loading order: $e');
      AppToast.error('Failed to load order details');
      isLoading.value = false;
    }
  }

  /// Search for order in OrdersController cache
  OrderModel? _findOrderInCache(int orderId) {
    try {
      final ordersController = OrdersController.instance;

      // Search in current orders list
      for (final order in ordersController.orders) {
        if (order.id == orderId) {
          return order;
        }
      }
    } catch (e) {
      print('⚠️ OrdersController not available: $e');
    }
    return null;
  }

  /// Refresh order data (pull to refresh)
  Future<void> refreshOrder() async {
    final order = selectedOrder.value;
    if (order == null) return;

    print('🔄 Refreshing order: ${order.orderReferenceId}');

    // Force refresh from API
    isLoading.value = true;
    final result = await _orderRepository.fetchOrderById(order.id);
    isLoading.value = false;

    result.fold(
      (failure) {
        print('❌ Order refresh failed: ${failure.message}');
        AppToast.error('Failed to refresh order: ${failure.message}');
      },
      (updatedOrder) {
        selectedOrder.value = updatedOrder;
        print('🔄 Order updated: ${updatedOrder.orderReferenceId}');

        // Also invalidate OrdersController cache
        try {
          final ordersController = OrdersController.instance;
          ordersController.invalidateCache(null);
        } catch (e) {
          print('⚠️ Could not invalidate cache: $e');
        }
      },
    );
  }
}
