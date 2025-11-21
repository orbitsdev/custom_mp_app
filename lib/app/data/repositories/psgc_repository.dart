// lib/app/data/repositories/psgc_repository.dart
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/region_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class PSGCRepository {
  /// GET /api/web/psgc/regions
  EitherModel<List<RegionModel>> fetchRegions() async {
    try {
      final dio = DioClient.public;

      final response = await dio.get('web/psgc/regions');

      final list = (response.data as List)
          .map((e) => RegionModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return right(list);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to load regions: $e'));
    }
  }

  /// GET /api/web/psgc/provinces?filter[regionCode]=XXXX
  EitherModel<List<RegionModel>> fetchProvinces(String regionCode) async {
    try {
      final dio = DioClient.public;

      final response = await dio.get(
        'web/psgc/provinces',
        queryParameters: {
          'filter[regionCode]': regionCode,
        },
      );

      final list = (response.data as List)
          .map((e) => RegionModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return right(list);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to load provinces: $e'));
    }
  }

  /// GET /api/web/psgc/municipalities?filter[provinceCode]=XXXX
  EitherModel<List<RegionModel>> fetchMunicipalities(String provinceCode) async {
    try {
      final dio = DioClient.public;

      final response = await dio.get(
        'web/psgc/municipalities',
        queryParameters: {
          'filter[provinceCode]': provinceCode,
        },
      );

      final list = (response.data as List)
          .map((e) => RegionModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return right(list);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to load municipalities: $e'));
    }
  }

  /// GET /api/web/psgc/barangays/{municipalityCode}
  EitherModel<List<RegionModel>> fetchBarangays(String municipalityCode) async {
    try {
      final dio = DioClient.public;

      final response =
          await dio.get('web/psgc/barangays/$municipalityCode');

      final list = (response.data as List)
          .map((e) => RegionModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return right(list);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to load barangays: $e'));
    }
  }
}
