import 'dart:io';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/review_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Controller for Write Review page
///
/// Features:
/// - Interactive 5-star rating
/// - Comment text input
/// - Multi-file upload (images/videos, max 5 files)
/// - File validation (type, size)
/// - Progress tracking during upload
/// - Success/error feedback
class WriteReviewController extends GetxController {
  static WriteReviewController get instance => Get.find();

  // Dependencies
  final _reviewRepo = ReviewRepository();

  // State variables
  final rating = 1.0.obs;
  final comment = ''.obs;
  final selectedFiles = <File>[].obs;
  final isLoading = false.obs;
  final uploadProgress = 0.0.obs;
  final isPickingFile = false.obs;

  // Product being reviewed (passed as argument)
  late ProductModel product;

  // Constants
  static const int maxFiles = 5;
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'];

  @override
  void onInit() {
    super.onInit();

    // Get product from arguments
    final args = Get.arguments;
    if (args is ProductModel) {
      product = args;
    } else if (args is Map && args.containsKey('product')) {
      product = args['product'] as ProductModel;
    } else {
      // Handle error - no product provided
      Get.back();
      AppToast.error('Product not found');
    }
  }

  /// Update rating value
  void updateRating(double newRating) {
    rating.value = newRating;
  }

  /// Update comment text
  void updateComment(String text) {
    comment.value = text;
  }

  /// Pick files (images/videos)
  Future<void> pickFiles() async {
    // Prevent multiple file pickers
    if (isPickingFile.value) {
      AppToast.info('File picker is already active');
      return;
    }

    // Check file limit
    if (selectedFiles.length >= maxFiles) {
      AppToast.warning('Maximum $maxFiles files allowed');
      return;
    }

    try {
      isPickingFile.value = true;

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        final files = result.files;

        for (final fileData in files) {
          // Check if we've reached the limit
          if (selectedFiles.length >= maxFiles) {
            AppToast.warning('Maximum $maxFiles files reached');
            break;
          }

          // Validate file size
          if (fileData.size > maxFileSizeBytes) {
            final fileSizeMB = (fileData.size / (1024 * 1024)).toStringAsFixed(1);
            AppToast.warning(
              '${fileData.name} is too large ($fileSizeMB MB). Max 10 MB per file.',
            );
            continue;
          }

          // Add file
          final file = File(fileData.path!);
          selectedFiles.add(file);
        }

        if (selectedFiles.isNotEmpty) {
          AppToast.success('${selectedFiles.length} file(s) selected');
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'read_external_storage_denied') {
        AppToast.error('Storage permission denied');
      } else {
        AppToast.error('Failed to pick files: ${e.message}');
      }
    } catch (e) {
      AppToast.error('Failed to pick files: $e');
    } finally {
      isPickingFile.value = false;
    }
  }

  /// Remove a file from the selected list
  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
      AppToast.info('File removed');
    }
  }

  /// Clear all selected files
  void clearFiles() {
    selectedFiles.clear();
    AppToast.info('All files removed');
  }

  /// Validate review before submission
  bool _validateReview() {
    // Rating is always valid (1-5)

    // Comment is optional but if provided, check length
    if (comment.value.length > 1000) {
      AppToast.error('Comment must not exceed 1000 characters');
      return false;
    }

    // Files are optional but already validated during selection

    return true;
  }

  /// Submit review
  Future<void> submitReview() async {
    // Validate
    if (!_validateReview()) {
      return;
    }

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AppModal.confirmation(
        title: 'Submit Review?',
        message: 'Are you sure you want to submit this review for ${product.name}?',
        confirmText: 'Submit',
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
      barrierDismissible: false,
    );

    if (confirmed != true) return;

    // Start loading
    isLoading.value = true;
    uploadProgress.value = 0.0;

    try {
      // Submit review
      final result = await _reviewRepo.submitReview(
        productId: product.id!,
        rating: rating.value.toInt(),
        comment: comment.value.isNotEmpty ? comment.value : null,
        attachments: selectedFiles.isNotEmpty ? selectedFiles : null,
        onSendProgress: (sent, total) {
          uploadProgress.value = sent / total;
        },
      );

      result.fold(
        (failure) {
          // Show error
          isLoading.value = false;
          uploadProgress.value = 0.0;

          Get.dialog(
            AppModal.error(
              title: 'Submission Failed',
              message: failure.message,
              onConfirm: () => Get.back(),
            ),
          );
        },
        (success) {
          // Success!
          isLoading.value = false;
          uploadProgress.value = 0.0;

          // Clear form
          rating.value = 1.0;
          comment.value = '';
          selectedFiles.clear();

          // Show success message
          AppToast.success('Review submitted successfully!');

          // Go back and refresh product details
          Get.back(result: true); // Return true to indicate success
        },
      );
    } catch (e) {
      isLoading.value = false;
      uploadProgress.value = 0.0;

      Get.dialog(
        AppModal.error(
          title: 'Unexpected Error',
          message: 'An unexpected error occurred: $e',
          onConfirm: () => Get.back(),
        ),
      );
    }
  }

  @override
  void onClose() {
    // Clean up
    selectedFiles.clear();
    super.onClose();
  }
}
