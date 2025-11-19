import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_response_model.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_summary_model.dart';

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


  EitherModel<List<CartItemModel>> fetchCart() async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.get('cart');

        final List<dynamic> data = response.data['data'] ?? [];
        final carts = data.map((e)=> CartItemModel.fromMap(e)).toList();
        return right(carts);

      } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }


    EitherModel<void> removeItem(int cartItemId) async {
    try {
      final dio = await DioClient.auth;
      await dio.delete('cart/$cartItemId');
      return right(null);

    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }


   EitherModel<void> updateQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final dio = await DioClient.auth;

      await dio.put(
        'cart/$cartItemId/quantity',
        data: { 'quantity': quantity },
      );

      return right(null);

    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

   EitherModel<void> updateSelection({
    required int cartItemId,
    required bool isSelected,
  }) async {
    try {
      final dio = await DioClient.auth;

      await dio.put(
        'cart/$cartItemId/select',
        data: { 'selected': isSelected },
      );

      return right(null);

    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  EitherModel<void> selectAll({required bool isSelected}) async {
    try {
      final dio = await DioClient.auth;

      await dio.put(
        'cart/select-all',
        data: { 'selected': isSelected },
      );

      return right(null);

    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

 EitherModel<CartSummaryModel> fetchCartSummary() async {
  try {
    final dio = await DioClient.auth;
    final response = await dio.get('cart/summary');

    final data = response.data['data'];
    final summary = CartSummaryModel.fromMap(data);

    return right(summary);
  } on DioException catch (e) {
    return left(FailureModel.fromDio(e));
  } catch (e) {
    return left(FailureModel.manual('Unexpected error: $e'));
  }
}

  

}
