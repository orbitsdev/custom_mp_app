import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_response_model.dart';

import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:custom_mp_app/app/core/plugins/storage/get_storage_service.dart';
import 'package:custom_mp_app/app/data/models/user/user_model.dart';

class CartRepository {

 EitherModel<CartItemModel> addToCart({
    required int productId,
    required List<int> optionIds,
    required int quantity,
  }) async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.post(
        'cart',
        data: {
          'product_id': productId,
          'option_ids': optionIds,
          'quantity': quantity,
        },
      );

      final data = response.data['data'];
      final cartItem = CartItemModel.fromMap(data);

      return right(cartItem);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
