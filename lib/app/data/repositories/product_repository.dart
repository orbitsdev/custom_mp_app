import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/models/products/product_pagination_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';

class ProductRepository {
  EitherModel<ProductPaginationResponse> fetchProducts({
    int page = 1,
    bool includeRelations = true,
  }) async {
    try {
      final dio = await DioClient.auth;

      final query = {
        'page': page,
        if (includeRelations)
          'include':
              'media,categories,variants.media,variants.options.attribute,attributes.options',
      };

      final response = await dio.get('products', queryParameters: query);

      final parsed = ProductPaginationResponse.fromJson(response.data);

      print('📦 Page $page loaded: ${parsed.items.length} products');

      return right(parsed);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
  

  EitherModel<ProductModel> fetchProductBySlug(String slug) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get(
        'products/$slug',
        queryParameters: {
          'include':
              'variants.media,variants.options.attribute,categories,attributes.options,media',
        },
      );

      final product = ProductModel.fromMap(response.data['data']);
      return right(product);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
