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
  Future<Either<FailureModel, Map<String, dynamic>>> fetchOrdersByStatus({
    OrderStatus? status,
    int page = 1,
  }) async {
    return status == null
        ? await _orderRepo.fetchAllOrders(page: page)
        : await _orderRepo.fetchOrders(page: page, orderStatus: status);
  }
}
