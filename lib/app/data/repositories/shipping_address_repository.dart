import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/shipping_address_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ShippingAddressRepository {
  EitherModel<List<ShippingAddressModel>> fetchAddresses() async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get('shipping-addresses');

      final list = (response.data['data'] as List)
          .map((e) => ShippingAddressModel.fromMap(e))
          .toList();

      return right(list);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  EitherModel<ShippingAddressModel> createAddress(
      Map<String, dynamic> payload) async {
    try {
      final dio = await DioClient.auth;

      final response =
          await dio.post('shipping-addresses', data: payload);

      return right(ShippingAddressModel.fromMap(response.data['data']));
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  EitherModel<ShippingAddressModel> updateAddress(
      int id, Map<String, dynamic> payload) async {
    try {
      final dio = await DioClient.auth;

      final response =
          await dio.put('shipping-addresses/$id', data: payload);

      return right(ShippingAddressModel.fromMap(response.data['data']));
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  EitherModel<bool> deleteAddress(int id) async {
    try {
      final dio = await DioClient.auth;

      await dio.delete('shipping-addresses/$id');

      return right(true);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  EitherModel<ShippingAddressModel> setDefault(int id) async {
    try {
      final dio = await DioClient.auth;

      final response =
          await dio.patch('shipping-addresses/$id/set-default');

      return right(ShippingAddressModel.fromMap(response.data['data']));
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
