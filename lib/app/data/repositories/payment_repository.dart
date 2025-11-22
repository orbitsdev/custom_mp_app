import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/payment/checkout_model.dart';
import 'package:custom_mp_app/app/data/models/payment/order_status_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class PaymentRepository {
  /// Create checkout session
  /// POST /api/mobile/checkout
  EitherModel<CheckoutModel> createCheckout({
    int? packageId,
    required int shippingAddressId,
  }) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.post(
        'mobile/checkout',
        data: {
          if (packageId != null) 'package_id': packageId,
          'shipping_address_id': shippingAddressId,
        },
      );

      final data = response.data['data'];
      final checkout = CheckoutModel.fromMap(data);

      return right(checkout);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Fetch order status
  /// GET /api/mobile/orders/{orderReferenceId}
  EitherModel<OrderStatusModel> fetchOrderStatus(String orderReferenceId) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get('mobile/orders/$orderReferenceId');

      final data = response.data['data'];
      final orderStatus = OrderStatusModel.fromMap(data);

      return right(orderStatus);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}