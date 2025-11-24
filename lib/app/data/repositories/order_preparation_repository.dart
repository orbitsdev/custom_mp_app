import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/format_helper.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/orderpreparation/order_package_model.dart';
import 'package:custom_mp_app/app/data/models/orderpreparation/order_preparation_model.dart';
import 'package:custom_mp_app/app/data/models/orderpreparation/order_summary_model.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/shipping_address_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class OrderPreparationRepository {
  EitherModel<OrderPreparationModel> fetchOrderPreparation({
    int? packageId, // optional
  }) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get(
        'order-preparation',
        queryParameters: {if (packageId != null) 'package_id': packageId},
      );

      final data = response.data['data'];

      final preparation = OrderPreparationModel.fromMap(data);

      return right(preparation);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
