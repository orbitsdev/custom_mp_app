import 'dart:io';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/reviews/controllers/submit_review_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitReviewPage extends StatelessWidget {
  const SubmitReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitReviewController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
        elevation: 0,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            if (controller.productName != null) ...[
              Text(
                'Reviewing:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.productName!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Rating Section
            const Text(
              'Rating',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return GestureDetector(
                      onTap: () => controller.setRating(starValue),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          starValue <= controller.rating.value
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                )),
            const SizedBox(height: 24),

            // Comment Section
            const Text(
              'Your Review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 6,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'Share your experience with this product...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.brand, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => controller.commentText.value = value,
            ),
            const SizedBox(height: 24),

            // Attachments Section
            const Text(
              'Add Photos or Videos (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // File Preview Grid
            Obx(() => controller.selectedFiles.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: controller.selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = controller.selectedFiles[index];
                      final isVideo = controller.isVideoFile(file);

                      return Stack(
                        children: [
                          _buildFileThumbnail(file, isVideo),
                          // Remove button
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => controller.removeFile(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          // Video indicator
                          if (isVideo)
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'Video',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  )
                : const SizedBox.shrink()),

            Obx(() => controller.selectedFiles.isNotEmpty
                ? const SizedBox(height: 12)
                : const SizedBox.shrink()),

            // Add Media Button (Single button like Shopee/Lazada)
            Obx(() => controller.selectedFiles.length < SubmitReviewController.maxFiles
                ? OutlinedButton.icon(
                    onPressed: () => _showMediaSourceDialog(context, controller),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    icon: const Icon(Icons.add_photo_alternate, size: 20),
                    label: const Text(
                      'Add Photos or Videos',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                : const SizedBox.shrink()),

            // File Count Info
            Obx(() => controller.selectedFiles.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${controller.selectedFiles.length}/${SubmitReviewController.maxFiles} files selected',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: 24),

            // Upload Progress
            Obx(() {
              if (controller.isLoading.value && controller.uploadProgress.value > 0) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: controller.uploadProgress.value,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% uploaded',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // Submit Button
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: controller.isLoading.value
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
                          ),
                        ),
                )),

            const SizedBox(height: 24),

            // Guidelines
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Review Guidelines',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Be honest and specific about your experience\n'
                    '• Maximum 6 photos or videos (10MB each)\n'
                    '• Keep comments respectful and relevant\n'
                    '• You can submit multiple reviews for this product',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMediaSourceDialog(BuildContext context, SubmitReviewController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Photos or Videos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.blue, size: 28),
                ),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Use camera to capture',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Get.back();
                  controller.pickMediaFromCamera();
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.green, size: 28),
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Select photos or videos',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Get.back();
                  controller.pickMediaFromGallery();
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileThumbnail(File file, bool isVideo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isVideo
            ? Stack(
                alignment: Alignment.center,
                children: [
                  // Gray background for video
                  Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.videocam,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              )
            : Image.file(
                file,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image fails to load
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
