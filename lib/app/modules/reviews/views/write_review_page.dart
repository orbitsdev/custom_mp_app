import 'dart:io';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/modules/reviews/controllers/write_review_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

/// Write Review Page
///
/// Allows users to submit reviews with:
/// - 5-star rating
/// - Comment text
/// - Image/video attachments (up to 5 files)
class WriteReviewPage extends StatelessWidget {
  const WriteReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WriteReviewController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(FluentIcons.arrow_left_24_regular),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Write Review',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;

        return Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product info
                    _buildProductInfo(controller),

                    const Gap(24),

                    // Rating section
                    _buildRatingSection(controller),

                    const Gap(24),

                    // Upload progress (shown during upload)
                    if (isLoading && controller.selectedFiles.isNotEmpty)
                      _buildUploadProgress(controller),

                    if (isLoading && controller.selectedFiles.isNotEmpty)
                      const Gap(16),

                    // Comment section
                    _buildCommentSection(controller),

                    const Gap(24),

                    // Attachments section
                    _buildAttachmentsSection(controller),

                    const Gap(80), // Space for submit button
                  ],
                ),
              ),
            ),

            // Submit button (fixed at bottom)
            _buildSubmitButton(controller),
          ],
        );
      }),
    );
  }

  Widget _buildProductInfo(WriteReviewController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade200,
              child: controller.product.thumbnail != null
                  ? Image.network(
                      controller.product.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        FluentIcons.image_24_regular,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Icon(
                      FluentIcons.image_24_regular,
                      color: Colors.grey.shade400,
                    ),
            ),
          ),

          const Gap(12),

          // Product name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.product.name ?? 'Product',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (controller.product.price != null) ...[
                  const Gap(4),
                  Text(
                    '₱${controller.product.price!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.brand,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(WriteReviewController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        Center(
          child: Obx(() {
            return RatingBar.builder(
              initialRating: controller.rating.value,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 40,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => Icon(
                FluentIcons.star_24_filled,
                color: AppColors.brand,
              ),
              onRatingUpdate: (rating) {
                controller.updateRating(rating);
              },
              unratedColor: Colors.grey.shade300,
            );
          }),
        ),
        const Gap(8),
        Obx(() {
          final rating = controller.rating.value;
          String ratingText;

          if (rating == 1) {
            ratingText = 'Poor';
          } else if (rating == 2) {
            ratingText = 'Fair';
          } else if (rating == 3) {
            ratingText = 'Good';
          } else if (rating == 4) {
            ratingText = 'Very Good';
          } else {
            ratingText = 'Excellent';
          }

          return Center(
            child: Text(
              ratingText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUploadProgress(WriteReviewController controller) {
    return Obx(() {
      final progress = controller.uploadProgress.value;
      final percentage = (progress * 100).toStringAsFixed(0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Uploading...',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.brand,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand),
              minHeight: 6,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCommentSection(WriteReviewController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comment (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        TextField(
          maxLines: 5,
          maxLength: 1000,
          decoration: InputDecoration(
            hintText: 'Share your experience with this product...',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.brand,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.all(12),
          ),
          onChanged: (value) {
            controller.updateComment(value);
          },
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection(WriteReviewController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Photos & Videos (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Obx(() {
              final count = controller.selectedFiles.length;
              return Text(
                '$count/${WriteReviewController.maxFiles}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
          ],
        ),
        const Gap(12),
        Obx(() {
          final files = controller.selectedFiles;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: files.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              // Add button (always first)
              if (index == 0) {
                return _buildAddButton(controller);
              }

              // File preview
              final file = files[index - 1];
              final fileIndex = index - 1;

              return _buildFilePreview(controller, file, fileIndex);
            },
          );
        }),
      ],
    );
  }

  Widget _buildAddButton(WriteReviewController controller) {
    return Obx(() {
      final isDisabled = controller.selectedFiles.length >= WriteReviewController.maxFiles ||
          controller.isLoading.value;

      return GestureDetector(
        onTap: isDisabled ? null : controller.pickFiles,
        child: Container(
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey.shade100 : AppColors.brand.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDisabled ? Colors.grey.shade300 : AppColors.brand,
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.add_24_regular,
                color: isDisabled ? Colors.grey.shade400 : AppColors.brand,
                size: 28,
              ),
              const Gap(4),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: 11,
                  color: isDisabled ? Colors.grey.shade400 : AppColors.brand,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFilePreview(WriteReviewController controller, File file, int index) {
    final isVideo = file.path.toLowerCase().endsWith('.mp4') ||
        file.path.toLowerCase().endsWith('.mov') ||
        file.path.toLowerCase().endsWith('.avi');

    return Stack(
      children: [
        // File preview
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isVideo
                ? _buildVideoPreview(file)
                : _buildImagePreview(file),
          ),
        ),

        // Remove button
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => controller.removeFile(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                FluentIcons.dismiss_24_filled,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),

        // Play icon for videos
        if (isVideo)
          Positioned.fill(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FluentIcons.play_24_filled,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImagePreview(File file) {
    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: Icon(
          FluentIcons.image_24_regular,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildVideoPreview(File file) {
    // For videos, show a placeholder with play icon
    return Container(
      color: Colors.black,
      child: Icon(
        FluentIcons.video_24_regular,
        color: Colors.grey.shade400,
        size: 32,
      ),
    );
  }

  Widget _buildSubmitButton(WriteReviewController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final isLoading = controller.isLoading.value;

        return GradientElevatedButton(
          style: GRADIENT_ELEVATED_BUTTON_STYLE,
          onPressed: isLoading ? null : controller.submitReview,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Submit Review',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        );
      }),
    );
  }
}
