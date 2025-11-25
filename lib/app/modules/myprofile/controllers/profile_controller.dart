import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // Use OrdersController as single source of truth for counts
  final OrdersController _ordersController = Get.find<OrdersController>();

  // Computed properties that reference OrdersController
  int get toPayCount => _ordersController.toPayCount.value;
  int get toShipCount => _ordersController.toShipCount.value;
  int get toReceiveCount => _ordersController.toReceiveCount.value;
  int get completedCount => _ordersController.completedCount.value;

  final isLoadingOrderCounts = false.obs;

  // Track last fetch time for smart refreshing
  DateTime? _lastFetchTime;

  // Refresh interval (30 seconds for real-time feel)
  static const _refreshInterval = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    fetchOrderCounts();
  }

  /// Check if data needs refresh (called when profile page is opened)
  Future<void> checkAndRefresh() async {
    if (_lastFetchTime == null ||
        DateTime.now().difference(_lastFetchTime!) > _refreshInterval) {
      await fetchOrderCounts();
    }
  }

  /// Fetch order counts for each status
  /// Now delegates to OrdersController for single source of truth
  Future<void> fetchOrderCounts() async {
    isLoadingOrderCounts.value = true;

    // Use OrdersController's refreshAllCounts method
    // This ensures counts are always in sync with actual orders
    await _ordersController.refreshAllCounts();

    // Update last fetch time
    _lastFetchTime = DateTime.now();

    isLoadingOrderCounts.value = false;
  }

  /// Refresh order counts (for pull-to-refresh)
  Future<void> refreshOrderCounts() async {
    await fetchOrderCounts();
  }
}
