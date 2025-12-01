import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/reviews/review_model.dart';

class ReviewRepository {
  /// Submit a new review for a product
  ///
  /// [productId] - The product ID to review
  /// [rating] - Rating from 1 to 5
  /// [comment] - Optional review comment
  /// [cartItemId] - Optional cart item ID (links review to specific purchase)
  /// [variantSnapshot] - Optional variant information (ignored if cartItemId provided)
  /// [attachments] - List of file paths for images/videos (max 6)
  EitherModel<ReviewModel> submitReview({
    required int productId,
    required int rating,
    String? comment,
    int? cartItemId,
    Map<String, dynamic>? variantSnapshot,
    List<String>? attachments,
    Function(double)? onUploadProgress,
  }) async {
    try {
      final dio = await DioClient.auth;

      // Create FormData for multipart upload
      final formData = FormData.fromMap({
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
        if (cartItemId != null) 'cart_item_id': cartItemId,
        if (variantSnapshot != null && cartItemId == null)
          'variant_snapshot': variantSnapshot,
      });

      // Add attachments if provided
      if (attachments != null && attachments.isNotEmpty) {
        for (var i = 0; i < attachments.length; i++) {
          final filePath = attachments[i];
          final fileName = filePath.split('/').last;
          formData.files.add(
            MapEntry(
              'attachments[$i]',
              await MultipartFile.fromFile(
                filePath,
                filename: fileName,
              ),
            ),
          );
        }
      }

      final response = await dio.post(
        'products/$productId/reviews',
        data: formData,
        onSendProgress: (sent, total) {
          if (onUploadProgress != null && total != -1) {
            onUploadProgress(sent / total);
          }
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return right(ReviewModel.fromMap(data));
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to submit review: $e'));
    }
  }

  /// Update an existing review
  EitherModel<ReviewModel> updateReview({
    required int reviewId,
    int? rating,
    String? comment,
    Map<String, dynamic>? variantSnapshot,
    List<String>? attachments,
    Function(double)? onUploadProgress,
  }) async {
    try {
      final dio = await DioClient.auth;

      final formData = FormData.fromMap({
        if (rating != null) 'rating': rating,
        if (comment != null) 'comment': comment,
        if (variantSnapshot != null) 'variant_snapshot': variantSnapshot,
      });

      // Add attachments if provided
      if (attachments != null && attachments.isNotEmpty) {
        for (var i = 0; i < attachments.length; i++) {
          final filePath = attachments[i];
          final fileName = filePath.split('/').last;
          formData.files.add(
            MapEntry(
              'attachments[$i]',
              await MultipartFile.fromFile(
                filePath,
                filename: fileName,
              ),
            ),
          );
        }
      }

      final response = await dio.post(
        'reviews/$reviewId',
        data: formData,
        queryParameters: {'_method': 'PUT'},
        onSendProgress: (sent, total) {
          if (onUploadProgress != null && total != -1) {
            onUploadProgress(sent / total);
          }
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return right(ReviewModel.fromMap(data));
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to update review: $e'));
    }
  }

  /// Delete a review
  EitherModel<void> deleteReview(int reviewId) async {
    try {
      final dio = await DioClient.auth;
      await dio.delete('reviews/$reviewId');
      return right(null);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to delete review: $e'));
    }
  }

  /// Get user's reviews
  EitherModel<List<ReviewModel>> getMyReviews({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final dio = await DioClient.auth;

      final response = await dio.get(
        'reviews/my-reviews',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'include': 'user,product,media',
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final items = data['items'] as List;
      final reviews = items
          .map((item) => ReviewModel.fromMap(item as Map<String, dynamic>))
          .toList();
      return right(reviews);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Failed to fetch reviews: $e'));
    }
  }
}
