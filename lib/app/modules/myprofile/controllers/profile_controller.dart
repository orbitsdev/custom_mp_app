import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/data/repositories/order_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final OrderRepository _orderRepo = OrderRepository();

  // Order counts by status
  final toPayCount = 0.obs;
  final toShipCount = 0.obs;
  final toReceiveCount = 0.obs;
  final completedCount = 0.obs;

  final isLoadingOrderCounts = false.obs;

  // Track last fetch time for smart refreshing
  DateTime? _lastFetchTime;

  // Refresh interval (5 minutes)
  static const _refreshInterval = Duration(minutes: 5);

  @override
  void onInit() {
    super.onInit();
    fetchOrderCounts();
  }

  /// Check if data needs refresh (called when profile page is opened)
  Future<void> checkAndRefresh() async {
    if (_lastFetchTime == null || DateTime.now().difference(_lastFetchTime!) > _refreshInterval) {
      await fetchOrderCounts();
    }
  }

  /// Fetch order counts for each status
  Future<void> fetchOrderCounts() async {
    isLoadingOrderCounts.value = true;

    // Fetch counts for each status in parallel
    await Future.wait([
      _fetchCountForStatus(OrderStatus.placed, toPayCount),
      _fetchCountForStatus(OrderStatus.processing, toShipCount),
      _fetchCountForStatus(OrderStatus.outForDelivery, toReceiveCount),
      _fetchCountForStatus(OrderStatus.delivered, completedCount),
    ]);

    // Update last fetch time
    _lastFetchTime = DateTime.now();

    isLoadingOrderCounts.value = false;
  }

  /// Fetch count for a specific status
  Future<void> _fetchCountForStatus(OrderStatus status, RxInt countObservable) async {
    final result = await _orderRepo.fetchOrders(
      page: 1,
      orderStatus: status,
    );

    result.fold(
      (failure) {
        // Silently fail - we don't want to show errors for counts
        print('Failed to fetch count for ${status.value}: ${failure.message}');
      },
      (data) {
        final pagination = data['pagination'];
        if (pagination != null) {
          countObservable.value = pagination.total ?? 0;
        }
      },
    );
  }

  /// Refresh order counts (for pull-to-refresh)
  Future<void> refreshOrderCounts() async {
    await fetchOrderCounts();
  }
}
