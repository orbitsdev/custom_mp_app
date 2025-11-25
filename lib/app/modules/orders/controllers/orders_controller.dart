import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/data/models/orders/order_pagination_model.dart';
import 'package:custom_mp_app/app/data/repositories/order_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final OrderRepository _orderRepo = OrderRepository();

  // State variables
  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final selectedStatus = Rx<OrderStatus?>(null);

  // Pagination
  final currentPage = 1.obs;
  final hasMorePages = true.obs;
  OrderPaginationModel? _paginationInfo;

  // Scroll controller for infinite scroll
  final ScrollController scrollController = ScrollController();

  // Cache management - Track last fetch time for each tab
  final Map<String, DateTime> _lastFetchTimes = {};
  final Map<String, List<OrderModel>> _ordersCache = {};
  final Map<String, OrderPaginationModel?> _paginationCache = {};

  // Cache validity duration
  // 15s = More API calls but fresher (Shopee-like)
  // 30s = Balanced (Current - Recommended)
  // 60s = Fewer API calls but less fresh
  static const _cacheValidityDuration = Duration(seconds: 15); // Shopee-like feel

  // Order counts (synchronized with actual orders)
  final toPayCount = 0.obs;
  final toShipCount = 0.obs;
  final toReceiveCount = 0.obs;
  final completedCount = 0.obs;
  final cancelledCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
  }

  @override
  void onReady() {
    super.onReady();
    fetchOrders();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Setup scroll listener for infinite scroll
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore.value &&
          hasMorePages.value) {
        loadMoreOrders();
      }
    });
  }

  /// Fetch orders (initial load or refresh)
  Future<void> fetchOrders({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    currentPage.value = 1;
    hasMorePages.value = true;

    final result = selectedStatus.value == null
        ? await _orderRepo.fetchAllOrders(page: 1)
        : await _orderRepo.fetchOrders(
            page: 1,
            orderStatus: selectedStatus.value,
          );

    result.fold(
      (failure) {
        AppToast.error(failure.message);
        isLoading.value = false;
      },
      (data) {
        orders.assignAll(data['orders'] as List<OrderModel>);
        _paginationInfo = data['pagination'] as OrderPaginationModel;
        hasMorePages.value = !_paginationInfo!.isLastPage;
        isLoading.value = false;
      },
    );
  }

  /// Load more orders (pagination)
  Future<void> loadMoreOrders() async {
    if (isLoadingMore.value || !hasMorePages.value) return;

    isLoadingMore.value = true;
    final nextPage = currentPage.value + 1;

    final result = selectedStatus.value == null
        ? await _orderRepo.fetchAllOrders(page: nextPage)
        : await _orderRepo.fetchOrders(
            page: nextPage,
            orderStatus: selectedStatus.value,
          );

    result.fold(
      (failure) {
        AppToast.error(failure.message);
        isLoadingMore.value = false;
      },
      (data) {
        final newOrders = data['orders'] as List<OrderModel>;
        orders.addAll(newOrders);

        _paginationInfo = data['pagination'] as OrderPaginationModel;
        currentPage.value = nextPage;
        hasMorePages.value = !_paginationInfo!.isLastPage;
        isLoadingMore.value = false;
      },
    );
  }

  /// Filter orders by status
  void filterByStatus(OrderStatus? status) {
    selectedStatus.value = status;
    fetchOrders();
  }

  /// Refresh orders (pull to refresh)
  Future<void> refreshOrders() async {
    await fetchOrders(showLoading: false);
  }

  /// Get orders count by status
  int getOrdersCountByStatus(OrderStatus status) {
    return orders.where((order) => order.orderStatus == status).length;
  }

  /// Check if there are any orders
  bool get hasOrders => orders.isNotEmpty;

  /// Get active orders (processing, preparing, out_for_delivery)
  List<OrderModel> get activeOrders => orders
      .where((order) =>
          order.orderStatus == OrderStatus.processing ||
          order.orderStatus == OrderStatus.preparing ||
          order.orderStatus == OrderStatus.outForDelivery)
      .toList();

  /// Get completed orders
  List<OrderModel> get completedOrders => orders
      .where((order) =>
          order.orderStatus == OrderStatus.delivered ||
          order.orderStatus == OrderStatus.completed)
      .toList();

  /// Get pending orders
  List<OrderModel> get pendingOrders => orders
      .where((order) =>
          order.orderStatus == OrderStatus.pending ||
          order.orderStatus == OrderStatus.placed)
      .toList();

  /// Fetch orders by specific status (for tab pages)
  /// Now with smart caching and automatic count updates
  Future<Either<FailureModel, Map<String, dynamic>>> fetchOrdersByStatus({
    OrderStatus? status,
    int page = 1,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _getCacheKey(status);

    // Check cache validity
    if (!forceRefresh && page == 1 && _isCacheValid(cacheKey)) {
      // Return cached data
      return right({
        'orders': _ordersCache[cacheKey] ?? [],
        'pagination': _paginationCache[cacheKey],
      });
    }

    // Fetch fresh data
    final result = status == null
        ? await _orderRepo.fetchAllOrders(page: page)
        : await _orderRepo.fetchOrders(page: page, orderStatus: status);

    // Update cache and counts if successful
    result.fold(
      (_) {}, // On failure, do nothing
      (data) {
        if (page == 1) {
          // Update cache for first page
          _ordersCache[cacheKey] = data['orders'] as List<OrderModel>;
          _paginationCache[cacheKey] = data['pagination'] as OrderPaginationModel?;
          _lastFetchTimes[cacheKey] = DateTime.now();

          // Update counts from pagination
          _updateCountFromPagination(status, data['pagination']);
        }
      },
    );

    return result;
  }

  /// Get cache key for a specific status
  String _getCacheKey(OrderStatus? status) {
    return status?.value ?? 'all';
  }

  /// Check if cache is still valid
  bool _isCacheValid(String cacheKey) {
    final lastFetch = _lastFetchTimes[cacheKey];
    if (lastFetch == null) return false;

    final age = DateTime.now().difference(lastFetch);
    return age < _cacheValidityDuration;
  }

  /// Update order count based on pagination data
  void _updateCountFromPagination(OrderStatus? status, OrderPaginationModel? pagination) {
    if (pagination == null) return;

    final count = pagination.total ?? 0;

    switch (status) {
      case OrderStatus.placed:
        toPayCount.value = count;
        break;
      case OrderStatus.processing:
        toShipCount.value = count;
        break;
      case OrderStatus.outForDelivery:
        toReceiveCount.value = count;
        break;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        completedCount.value = count;
        break;
      case OrderStatus.canceled:
        cancelledCount.value = count;
        break;
      default:
        break;
    }
  }

  /// Invalidate cache for a specific status (call after order status changes)
  void invalidateCache(OrderStatus? status) {
    final cacheKey = _getCacheKey(status);
    _lastFetchTimes.remove(cacheKey);
    _ordersCache.remove(cacheKey);
    _paginationCache.remove(cacheKey);
  }

  /// Invalidate all caches (call after major changes)
  void invalidateAllCaches() {
    _lastFetchTimes.clear();
    _ordersCache.clear();
    _paginationCache.clear();
  }

  /// Refresh all order counts (for profile page)
  Future<void> refreshAllCounts() async {
    await Future.wait([
      fetchOrdersByStatus(status: OrderStatus.placed, forceRefresh: true),
      fetchOrdersByStatus(status: OrderStatus.processing, forceRefresh: true),
      fetchOrdersByStatus(status: OrderStatus.outForDelivery, forceRefresh: true),
      fetchOrdersByStatus(status: OrderStatus.delivered, forceRefresh: true),
      fetchOrdersByStatus(status: OrderStatus.canceled, forceRefresh: true),
    ]);
  }
}
