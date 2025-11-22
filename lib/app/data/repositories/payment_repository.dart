import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/payment/checkout_model.dart';
import 'package:custom_mp_app/app/data/models/payment/order_status_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
class PaymentRepository {
  /// POST /mobile/checkout
  /// Backend automatically uses default shipping address
  EitherModel<CheckoutModel> createCheckout({
    int? packageId,
  }) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.post(
        'mobile/checkout',
        data: {
          if (packageId != null) 'package_id': packageId,
        },
      );

      final checkout = CheckoutModel.fromMap(response.data['data']);
      return right(checkout);

    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    }
  }

  /// GET /mobile/orders/{ref}
  EitherModel<OrderStatusModel> fetchOrderStatus(String ref) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get('mobile/orders/$ref');

      final status = OrderStatusModel.fromMap(response.data['data']);
      return right(status);

    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    }
  }
}
