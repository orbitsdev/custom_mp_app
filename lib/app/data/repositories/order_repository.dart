import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/orders/order_model.dart';
import 'package:custom_mp_app/app/data/models/orders/order_pagination_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class OrderRepository {
  /// Fetch orders with pagination and filters
  ///
  /// Parameters:
  /// - [page]: Page number (default: 1)
  /// - [orderStatus]: Filter by order status (null = default pending, empty string = all)
  /// - [isActive]: Filter by active status
  /// - [paymentType]: Filter by payment type (cod, gcash, etc.)
  /// - [deliveryType]: Filter by delivery type (delivery, pickup)
  /// - [include]: Load relationships (user, package, payments, orderStatusLogs)
  ///
  /// Note: Backend defaults to PENDING orders when no filter is provided
  EitherModel<Map<String, dynamic>> fetchOrders({
    int page = 1,
    OrderStatus? orderStatus,
    bool? isActive,
    String? paymentType,
    String? deliveryType,
    List<String>? include,
  }) async {
    try {
      final dio = await DioClient.auth;

      final queryParams = <String, dynamic>{
        'page': page,
      };

      // Add filters if provided
      if (orderStatus != null) {
        queryParams['filter[order_status]'] = orderStatus.value;
      }
      if (isActive != null) {
        queryParams['filter[is_active]'] = isActive ? 1 : 0;
      }
      if (paymentType != null) {
        queryParams['filter[payment_type]'] = paymentType;
      }
      if (deliveryType != null) {
        queryParams['filter[delivery_type]'] = deliveryType;
      }
      if (include != null && include.isNotEmpty) {
        queryParams['include'] = include.join(',');
      }

      final response = await dio.get(
        'orders',
        queryParameters: queryParams,
      );

        final data = response.data['data'];

      // Parse orders list
      final ordersList = (data['items'] as List)
          .map((json) => OrderModel.fromMap(json))
          .toList();

      // Parse pagination
      final pagination = OrderPaginationModel.fromMap(data['pagination']);

      return right({
        'orders': ordersList,
        'pagination': pagination,
      });
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Fetch single order details by ID
  ///
  /// Backend auto-includes: user, package, payments, orderStatusLogs
  EitherModel<OrderModel> fetchOrderById(int orderId) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get('orders/$orderId');

      final order = OrderModel.fromMap(response.data['data']);
      return right(order);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Fetch all orders (bypass default pending filter by sending empty status)
  ///
  /// Backend behavior:
  /// - No filter param → Returns PENDING orders only (default)
  /// - filter[order_status]="" → Returns ALL orders (bypasses default)
  EitherModel<Map<String, dynamic>> fetchAllOrders({
    int page = 1,
    List<String>? include,
  }) async {
    try {
      final dio = await DioClient.auth;

      final queryParams = <String, dynamic>{
        'page': page,
        'filter[order_status]': '', // Empty string bypasses default pending filter
      };

      if (include != null && include.isNotEmpty) {
        queryParams['include'] = include.join(',');
      }

      final response = await dio.get(
        'orders',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      final ordersList = (data['items'] as List)
          .map((json) => OrderModel.fromMap(json))
          .toList();

      final pagination = OrderPaginationModel.fromMap(data['pagination']);

      return right({
        'orders': ordersList,
        'pagination': pagination,
      });
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
