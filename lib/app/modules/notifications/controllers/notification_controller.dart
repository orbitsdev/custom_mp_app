import 'package:custom_mp_app/app/data/models/notification/notification_model.dart';
import 'package:custom_mp_app/app/data/repositories/notification_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';

/// Notification Controller
///
/// Manages notification state and actions with API integration
/// Registered in HomeBinding as permanent controller
class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final _repository = NotificationRepository();

  // Observable notifications list
  final notifications = <NotificationModel>[].obs;

  // Loading states
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;

  // Unread count
  final unreadCount = 0.obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;
  final hasMore = true.obs;

  // Cache management (15-second validity like OrdersController)
  DateTime? _lastFetched;
  final _cacheValidityDuration = const Duration(seconds: 15);

  bool get _isCacheValid {
    if (_lastFetched == null) return false;
    return DateTime.now().difference(_lastFetched!) < _cacheValidityDuration;
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  /// Invalidate cache to force refresh
  void invalidateCache() {
    _lastFetched = null;
  }

  /// Fetch notifications with pagination
  Future<void> fetchNotifications({bool forceRefresh = false}) async {
    // Use cache if valid and not forcing refresh
    if (_isCacheValid && !forceRefresh && notifications.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    currentPage.value = 1;

    final result = await _repository.fetchNotifications(page: 1);

    result.fold(
      (failure) {
        isLoading.value = false;
        AppModal.error(
          title: 'Error',
          message: failure.message,
        );
      },
      (data) {
        final notificationsList = data['notifications'] as List<NotificationModel>;
        final pagination = data['pagination'] as Map<String, dynamic>;

        notifications.value = notificationsList;
        currentPage.value = pagination['current_page'];
        lastPage.value = pagination['last_page'];
        total.value = pagination['total'];
        hasMore.value = currentPage.value < lastPage.value;

        _lastFetched = DateTime.now();
        isLoading.value = false;
      },
    );
  }

  /// Load more notifications (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;

    final nextPage = currentPage.value + 1;

    final result = await _repository.fetchNotifications(page: nextPage);

    result.fold(
      (failure) {
        isLoadingMore.value = false;
        AppToast.error(failure.message);
      },
      (data) {
        final notificationsList = data['notifications'] as List<NotificationModel>;
        final pagination = data['pagination'] as Map<String, dynamic>;

        notifications.addAll(notificationsList);
        currentPage.value = pagination['current_page'];
        lastPage.value = pagination['last_page'];
        total.value = pagination['total'];
        hasMore.value = currentPage.value < lastPage.value;

        isLoadingMore.value = false;
      },
    );
  }

  /// Refresh notifications (pull-to-refresh)
  @override
  Future<void> refresh() async {
    isRefreshing.value = true;

    await fetchNotifications(forceRefresh: true);
    await fetchUnreadCount();

    isRefreshing.value = false;
  }

  /// Fetch unread notification count
  Future<void> fetchUnreadCount() async {
    final result = await _repository.fetchUnreadCount();

    result.fold(
      (failure) {
        // Silent fail for count - not critical
      },
      (count) {
        unreadCount.value = count;
      },
    );
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final result = await _repository.markAsRead(notificationId);

    result.fold(
      (failure) {
        AppToast.error(failure.message);
      },
      (updatedNotification) {
        // Update local list
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = updatedNotification;
          notifications.refresh();
        }

        // Update unread count
        fetchUnreadCount();
      },
    );
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    final result = await _repository.markAllAsRead();

    result.fold(
      (failure) {
        AppModal.error(
          title: 'Error',
          message: failure.message,
        );
      },
      (updatedCount) {
        // Update local list
        notifications.value = notifications
            .map((notification) => notification.copyWith(
                  isRead: true,
                  readAt: DateTime.now().toIso8601String(),
                ))
            .toList();

        // Update unread count
        unreadCount.value = 0;

        AppToast.success('$updatedCount notifications marked as read');
      },
    );
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final result = await _repository.deleteNotification(notificationId);

    result.fold(
      (failure) {
        AppToast.error(failure.message);
      },
      (_) {
        // Remove from local list
        notifications.removeWhere((n) => n.id == notificationId);

        // Update count
        total.value = total.value - 1;

        // Update unread count
        fetchUnreadCount();

        AppToast.success('Notification deleted');
      },
    );
  }

  /// Clear all read notifications
  Future<void> clearReadNotifications() async {
    final result = await _repository.clearReadNotifications();

    result.fold(
      (failure) {
        AppModal.error(
          title: 'Error',
          message: failure.message,
        );
      },
      (deletedCount) {
        // Remove read notifications from local list
        notifications.removeWhere((n) => n.isRead);

        // Update total count
        total.value = total.value - deletedCount;

        AppToast.success('$deletedCount read notifications cleared');
      },
    );
  }

  /// Clear all notifications (for testing/development)
  void clearAllLocal() {
    notifications.clear();
    unreadCount.value = 0;
    total.value = 0;
    currentPage.value = 1;
    lastPage.value = 1;
    hasMore.value = true;
    invalidateCache();
  }
}
