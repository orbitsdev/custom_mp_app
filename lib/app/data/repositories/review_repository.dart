import 'dart:io';
import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';

/// Review Repository for submitting, updating, and deleting product reviews
///
/// API Documentation: docs/API_REVIEW_ROUTES.md
///
/// Features:
/// - Submit review with rating, comment, and attachments (up to 5 files)
/// - Update existing reviews
/// - Delete reviews
/// - Progress tracking for file uploads
class ReviewRepository {
  /// Submit a review for a product
  ///
  /// API: POST /products/{productId}/reviews
  ///
  /// **Parameters:**
  /// - [productId] - Product ID to review
  /// - [rating] - Rating (1-5)
  /// - [comment] - Optional review comment (max 1000 characters)
  /// - [attachments] - Optional list of files (max 5, max 10MB each)
  /// - [onSendProgress] - Optional callback for upload progress
  ///
  /// **Returns:**
  /// - Success: Map containing review data
  /// - Failure: FailureModel with error message
  ///
  /// **Example:**
  /// ```dart
  /// final result = await reviewRepo.submitReview(
  ///   productId: 123,
  ///   rating: 5,
  ///   comment: 'Great product!',
  ///   attachments: [File('/path/image.jpg')],
  ///   onSendProgress: (sent, total) {
  ///     print('Progress: ${(sent / total * 100).toStringAsFixed(0)}%');
  ///   },
  /// );
  /// ```
  EitherModel<Map<String, dynamic>> submitReview({
    required int productId,
    required int rating,
    String? comment,
    List<File>? attachments,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final dio = await DioClient.auth;

      // Validate rating
      if (rating < 1 || rating > 5) {
        return left(FailureModel(
          message: 'Rating must be between 1 and 5',
        ));
      }

      // Validate attachments count
      if (attachments != null && attachments.length > 5) {
        return left(FailureModel(
          message: 'Maximum 5 attachments allowed',
        ));
      }

      // Build form data
      final formData = FormData();

      // Add rating (required)
      formData.fields.add(MapEntry('rating', rating.toString()));

      // Add comment (optional)
      if (comment != null && comment.isNotEmpty) {
        formData.fields.add(MapEntry('comment', comment));
      }

      // Add attachments (optional)
      if (attachments != null && attachments.isNotEmpty) {
        for (final file in attachments) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          formData.files.add(
            MapEntry(
              'attachments[]',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
              ),
            ),
          );
        }
      }

      print('📝 Submitting review for product $productId (rating: $rating)');

      final response = await dio.post(
        'products/$productId/reviews',
        data: formData,
        onSendProgress: onSendProgress,
      );

      print('✅ Review submitted successfully');

      return right(response.data);
    } on DioException catch (e) {
      print('❌ Review submission failed: ${e.message}');

      // Handle specific error cases
      if (e.response?.statusCode == 400) {
        // Duplicate review error
        return left(FailureModel(
          message: e.response?.data['message'] ??
            'You have already reviewed this product',
        ));
      }

      if (e.response?.statusCode == 422) {
        // Validation error
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        final firstError = errors?.values.first;
        final errorMessage = firstError is List ? firstError.first : firstError;

        return left(FailureModel(
          message: errorMessage ?? 'Validation failed',
        ));
      }

      return left(FailureModel(
        message: e.response?.data['message'] ?? e.message ?? 'Failed to submit review',
      ));
    } catch (e) {
      print('❌ Unexpected error: $e');
      return left(FailureModel(
        message: 'An unexpected error occurred: $e',
      ));
    }
  }

  /// Update an existing review
  ///
  /// API: PUT /reviews/{reviewId}
  ///
  /// **Note:** Users can only update their own reviews
  ///
  /// **Parameters:**
  /// - [reviewId] - Review ID to update
  /// - [rating] - Optional new rating (1-5)
  /// - [comment] - Optional new comment
  /// - [attachments] - Optional new attachments (replaces existing)
  /// - [onSendProgress] - Optional callback for upload progress
  ///
  /// **Returns:**
  /// - Success: Map containing updated review data
  /// - Failure: FailureModel with error message (403 if not owner)
  EitherModel<Map<String, dynamic>> updateReview({
    required int reviewId,
    int? rating,
    String? comment,
    List<File>? attachments,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final dio = await DioClient.auth;

      // Validate rating if provided
      if (rating != null && (rating < 1 || rating > 5)) {
        return left(FailureModel(
          message: 'Rating must be between 1 and 5',
        ));
      }

      // Validate attachments count
      if (attachments != null && attachments.length > 5) {
        return left(FailureModel(
          message: 'Maximum 5 attachments allowed',
        ));
      }

      // Build form data
      final formData = FormData();

      // Add rating (optional)
      if (rating != null) {
        formData.fields.add(MapEntry('rating', rating.toString()));
      }

      // Add comment (optional)
      if (comment != null) {
        formData.fields.add(MapEntry('comment', comment));
      }

      // Add attachments (optional, replaces existing)
      if (attachments != null && attachments.isNotEmpty) {
        for (final file in attachments) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          formData.files.add(
            MapEntry(
              'attachments[]',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
              ),
            ),
          );
        }
      }

      print('📝 Updating review $reviewId');

      final response = await dio.put(
        'reviews/$reviewId',
        data: formData,
        onSendProgress: onSendProgress,
      );

      print('✅ Review updated successfully');

      return right(response.data);
    } on DioException catch (e) {
      print('❌ Review update failed: ${e.message}');

      if (e.response?.statusCode == 403) {
        return left(FailureModel(
          message: 'You can only update your own reviews',
        ));
      }

      if (e.response?.statusCode == 404) {
        return left(FailureModel(
          message: 'Review not found',
        ));
      }

      return left(FailureModel(
        message: e.response?.data['message'] ?? e.message ?? 'Failed to update review',
      ));
    } catch (e) {
      print('❌ Unexpected error: $e');
      return left(FailureModel(
        message: 'An unexpected error occurred: $e',
      ));
    }
  }

  /// Delete a review
  ///
  /// API: DELETE /reviews/{reviewId}
  ///
  /// **Note:** Users can only delete their own reviews
  ///
  /// **Parameters:**
  /// - [reviewId] - Review ID to delete
  ///
  /// **Returns:**
  /// - Success: true
  /// - Failure: FailureModel with error message (403 if not owner)
  EitherModel<bool> deleteReview(int reviewId) async {
    try {
      final dio = await DioClient.auth;

      print('🗑️ Deleting review $reviewId');

      await dio.delete('reviews/$reviewId');

      print('✅ Review deleted successfully');

      return right(true);
    } on DioException catch (e) {
      print('❌ Review deletion failed: ${e.message}');

      if (e.response?.statusCode == 403) {
        return left(FailureModel(
          message: 'You can only delete your own reviews',
        ));
      }

      if (e.response?.statusCode == 404) {
        return left(FailureModel(
          message: 'Review not found',
        ));
      }

      return left(FailureModel(
        message: e.response?.data['message'] ?? e.message ?? 'Failed to delete review',
      ));
    } catch (e) {
      print('❌ Unexpected error: $e');
      return left(FailureModel(
        message: 'An unexpected error occurred: $e',
      ));
    }
  }
}
