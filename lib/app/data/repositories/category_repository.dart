import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/category/category_model.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// Repository for handling category-related API calls
class CategoryRepository {
  /// Fetch all categories
  EitherModel<List<CategoryModel>> fetchCategories() async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.get('categories');

      // ✅ Expected Laravel Response:
      // {
      //   "status": true,
      //   "message": "Categories retrieved successfully.",
      //   "data": [
      //     { "id": 1, "name": "Snacks", "slug": "snacks", ... }
      //   ]
      // }

      final List<dynamic> data = response.data['data'] ?? [];
      final categories = data
          .map((e) => CategoryModel.fromMap(e))
          .toList(growable: false);

      print('✅ Loaded ${categories.length} categories');
      return right(categories);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Fetch single category by slug (optional)
  EitherModel<CategoryModel> fetchCategoryBySlug(String slug) async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.get('categories/$slug');

      final category = CategoryModel.fromMap(response.data['data']);
      return right(category);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
