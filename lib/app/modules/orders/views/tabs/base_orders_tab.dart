import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_card.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_loading_card.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/orders_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BaseOrdersTab extends StatefulWidget {
  final OrderStatus? orderStatus;
  final String emptyTitle;
  final String emptySubtitle;

  const BaseOrdersTab({
    Key? key,
    this.orderStatus,
    required this.emptyTitle,
    required this.emptySubtitle,
  }) : super(key: key);

  @override
  State<BaseOrdersTab> createState() => _BaseOrdersTabState();
}

class _BaseOrdersTabState extends State<BaseOrdersTab>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final controller = Get.find<OrdersController>();
  late ScrollController scrollController;

  bool isInitialLoading = true;
  bool isLoadingMore = false;
  bool hasMorePages = true;
  int currentPage = 1;
  List<OrderModel> orders = [];

  // Track if tab has been visible before
  bool _hasBeenVisible = false;
  DateTime? _lastVisibleTime;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
    _fetchOrders();
    _hasBeenVisible = true;
    _lastVisibleTime = DateTime.now();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh when app comes back to foreground
    if (state == AppLifecycleState.resumed && _hasBeenVisible) {
      final now = DateTime.now();
      if (_lastVisibleTime != null &&
          now.difference(_lastVisibleTime!) > const Duration(seconds: 30)) {
        _fetchOrders();
      }
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMorePages) {
      _loadMore();
    }
  }

  Future<void> _fetchOrders() async {
    if (mounted) {
      setState(() {
        isInitialLoading = true;
        currentPage = 1;
      });
    }

    final result = await controller.fetchOrdersByStatus(
      status: widget.orderStatus,
      page: 1,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => isInitialLoading = false);
      },
      (data) {
        setState(() {
          orders = data['orders'] as List<OrderModel>;
          final pagination = data['pagination'];
          if (pagination != null) {
            hasMorePages = !pagination.isLastPage;
          } else {
            hasMorePages = false;
          }
          currentPage = 1;
          isInitialLoading = false;
        });
      },
    );
  }

  Future<void> _loadMore() async {
    if (isLoadingMore || !hasMorePages || isInitialLoading) return;

    setState(() => isLoadingMore = true);

    final nextPage = currentPage + 1;
    final result = await controller.fetchOrdersByStatus(
      status: widget.orderStatus,
      page: nextPage,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => isLoadingMore = false);
      },
      (data) {
        final newOrders = data['orders'] as List<OrderModel>;
        final pagination = data['pagination'];

        setState(() {
          orders.addAll(newOrders);
          if (pagination != null) {
            hasMorePages = !pagination.isLastPage;
          } else {
            hasMorePages = false;
          }
          currentPage = nextPage;
          isLoadingMore = false;
        });
      },
    );
  }

  Future<void> _refresh() async {
    await _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isInitialLoading) {
      return CustomScrollView(
        slivers: [
          const OrderLoadingCard(itemCount: 5),
        ],
      );
    }

    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: OrdersEmptyState(
                title: widget.emptyTitle,
                subtitle: widget.emptySubtitle,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverMasonryGrid.count(
              childCount: orders.length,
              crossAxisCount: 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 0,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  order: order,
                  onTap: () {
                    Get.toNamed(
                      Routes.orderDetailPage,
                      arguments: order,
                    );
                  },
                );
              },
            ),
          ),

          // Loading more indicator
          if (isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.brandDark,
                  ),
                ),
              ),
            ),

          // End of list message
          if (!hasMorePages && !isLoadingMore && orders.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No more orders',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
