import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/notification/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class NotificationRepository {
  /// Fetch all notifications with pagination
  ///
  /// Parameters:
  /// - [page]: Page number (default: 1)
  /// - [perPage]: Items per page (default: 20)
  ///
  /// Returns Either with notifications and pagination
  EitherModel<Map<String, dynamic>> fetchNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get(
        'notifications',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final dataWrapper = response.data['data'];

      // Parse notifications from 'items' array
      final items = dataWrapper['items'] as List;
      final notifications = items
          .map((json) => NotificationModel.fromMap(json))
          .toList();

      // Parse pagination
      final pagination = dataWrapper['pagination'];

      return right({
        'notifications': notifications,
        'pagination': {
          'current_page': pagination['current_page'],
          'last_page': pagination['last_page'],
          'per_page': pagination['per_page'],
          'total': pagination['total'],
          'next_page_url': pagination['next_page_url'],
          'prev_page_url': pagination['prev_page_url'],
        },
      });
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Fetch unread notifications with pagination
  ///
  /// Parameters:
  /// - [page]: Page number (default: 1)
  /// - [perPage]: Items per page (default: 20)
  ///
  /// Returns Either with unread notifications and pagination
  EitherModel<Map<String, dynamic>> fetchUnreadNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get(
        'notifications/unread',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final dataWrapper = response.data['data'];

      // Parse notifications from 'items' array
      final items = dataWrapper['items'] as List;
      final notifications = items
          .map((json) => NotificationModel.fromMap(json))
          .toList();

      // Parse pagination
      final pagination = dataWrapper['pagination'];

      return right({
        'notifications': notifications,
        'pagination': {
          'current_page': pagination['current_page'],
          'last_page': pagination['last_page'],
          'per_page': pagination['per_page'],
          'total': pagination['total'],
          'next_page_url': pagination['next_page_url'],
          'prev_page_url': pagination['prev_page_url'],
        },
      });
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Get unread notification count
  ///
  /// Returns Either with unread count
  EitherModel<int> fetchUnreadCount() async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get('notifications/unread-count');

      final count = response.data['data']['count'] as int;

      return right(count);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Mark a notification as read
  ///
  /// Parameters:
  /// - [notificationId]: UUID of the notification
  ///
  /// Returns Either with updated notification
  EitherModel<NotificationModel> markAsRead(String notificationId) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.post('notifications/$notificationId/mark-read');

      final notification = NotificationModel.fromMap(response.data['data']);

      return right(notification);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Mark all notifications as read
  ///
  /// Returns Either with count of updated notifications
  EitherModel<int> markAllAsRead() async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.post('notifications/mark-all-read');

      final updatedCount = response.data['data']['updated_count'] as int;

      return right(updatedCount);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Delete a notification
  ///
  /// Parameters:
  /// - [notificationId]: UUID of the notification
  ///
  /// Returns Either indicating success
  EitherModel<bool> deleteNotification(String notificationId) async {
    try {
      final dio = await DioClient.auth;

      await dio.delete('notifications/$notificationId');

      return right(true);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Clear all read notifications
  ///
  /// Returns Either with count of deleted notifications
  EitherModel<int> clearReadNotifications() async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.delete('notifications/read/clear');

      final deletedCount = response.data['data']['deleted_count'] as int;

      return right(deletedCount);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
