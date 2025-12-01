import 'dart:io';
import 'package:custom_mp_app/app/data/repositories/review_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SubmitReviewController extends GetxController {
  static SubmitReviewController get instance => Get.find();

  final _repository = ReviewRepository();
  final _picker = ImagePicker();

  // Observables
  final isLoading = false.obs;
  final uploadProgress = 0.0.obs;
  final rating = 0.obs;
  final commentText = ''.obs;
  final selectedFiles = <File>[].obs;

  // Maximum files allowed (as per API - updated to 6)
  static const int maxFiles = 6;

  // Product info (passed as argument)
  late int productId;
  String? productName;
  int? cartItemId; // Optional - links review to specific purchase

  @override
  void onInit() {
    super.onInit();

    // Get product info from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      productId = args['productId'] as int;
      productName = args['productName'] as String?;
      cartItemId = args['cartItemId'] as int?; // Optional
    }
  }

  /// Set rating (1-5)
  void setRating(int value) {
    if (value >= 1 && value <= 5) {
      rating.value = value;
    }
  }

  /// Pick media (image or video) from camera
  Future<void> pickMediaFromCamera() async {
    if (selectedFiles.length >= maxFiles) {
      AppToast.error('Maximum $maxFiles files allowed');
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedFiles.add(File(pickedFile.path));
      }
    } catch (e) {
      AppToast.error('Failed to capture photo: $e');
    }
  }

  /// Pick media (images/videos) from gallery
  /// Shows native picker that allows selecting photos AND videos
  Future<void> pickMediaFromGallery() async {
    if (selectedFiles.length >= maxFiles) {
      AppToast.error('Maximum $maxFiles files allowed');
      return;
    }

    try {
      // Use pickMultipleMedia for mixed selection (images + videos)
      // Note: This uses the native gallery picker which supports both
      final pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        final remainingSlots = maxFiles - selectedFiles.length;
        final filesToAdd = pickedFiles.take(remainingSlots);

        for (var pickedFile in filesToAdd) {
          final file = File(pickedFile.path);
          final fileSizeInMB = await file.length() / (1024 * 1024);

          if (fileSizeInMB > 10) {
            AppToast.error('${pickedFile.name}: File size must be less than 10MB');
            continue;
          }

          selectedFiles.add(file);
        }

        if (pickedFiles.length > remainingSlots) {
          AppToast.info('Only $remainingSlots files added (max $maxFiles total)');
        }
      }
    } catch (e) {
      AppToast.error('Failed to pick media: $e');
    }
  }

  /// Remove file at index
  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  /// Check if file is a video
  bool isVideoFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', '3gp'].contains(extension);
  }

  /// Check if file is an image
  bool isImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Submit review
  Future<void> submitReview() async {
    // Validation
    if (rating.value == 0) {
      AppToast.error('Please select a rating');
      return;
    }

    if (commentText.value.isEmpty && selectedFiles.isEmpty) {
      AppToast.error('Please add a comment or attach files');
      return;
    }

    isLoading.value = true;
    uploadProgress.value = 0.0;

    try {
      final filePaths = selectedFiles.map((f) => f.path).toList();

      final result = await _repository.submitReview(
        productId: productId,
        rating: rating.value,
        comment: commentText.value.isNotEmpty ? commentText.value : null,
        cartItemId: cartItemId, // Link to purchase if available
        attachments: filePaths.isNotEmpty ? filePaths : null,
        onUploadProgress: (progress) {
          uploadProgress.value = progress;
        },
      );

      result.fold(
        (failure) {
          AppModal.error(
            title: 'Submission Failed',
            message: failure.message,
          );
        },
        (review) {
          AppModal.success(
            title: 'Review Submitted',
            message: 'Thank you for your review!',
            onConfirm: () {
              Get.back(); // Close modal
              Get.back(result: true); // Go back to previous page with result
            },
          );
        },
      );
    } finally {
      isLoading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  @override
  void onClose() {
    // Clear files
    selectedFiles.clear();
    super.onClose();
  }
}
