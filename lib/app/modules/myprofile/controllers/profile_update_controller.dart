import 'dart:io';

import 'package:custom_mp_app/app/data/models/user/user_model.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ProfileUpdateController extends GetxController {
  static ProfileUpdateController get instance => Get.find();

  final _authRepo = AuthRepository();
  final _authController = Get.find<AuthController>();

  final isLoading = false.obs;
  final uploadProgress = 0.0.obs;

  UserModel? get currentUser => _authController.user.value;

  /// Update user profile details (name, email, password, account_information)
  ///
  /// Uses different feedback based on what was updated:
  /// - Password/Email: Modal (important changes, requires user acknowledgment)
  /// - Name/Account Info: Toast (quick feedback, less disruptive)
  Future<void> updateUserDetails(
    Map<String, dynamic> body, {
    bool useModal = false,
    String? successMessage,
  }) async {
    isLoading.value = true;

    final result = await _authRepo.updateUserDetails(body);

    result.fold(
      (failure) {
        AppModal.error(
          title: 'Update Failed',
          message: failure.message,
        );
      },
      (user) {
        _authController.user.value = user;

        // Determine if this is a critical update (password/email)
        final isCriticalUpdate = body.containsKey('password') ||
                                  body.containsKey('email');

        final message = successMessage ?? 'Profile updated successfully';

        // Use modal for critical updates or when explicitly requested
        if (useModal || isCriticalUpdate) {
          AppModal.success(
            title: 'Success',
            message: message,
            onConfirm: () => Get.back(), // Go back after modal closes
          );
        } else {
          // Use toast for quick updates
          AppToast.success(message);
          Get.back(); // Go back immediately
        }
      },
    );

    isLoading.value = false;
  }

  /// Upload avatar with progress tracking
  Future<void> uploadAvatar(String filePath) async {
    isLoading.value = true;
    uploadProgress.value = 0.0;

    final result = await _authRepo.uploadAvatar(
      filePath,
      onSendProgress: (sent, total) {
        if (total != -1) {
          uploadProgress.value = (sent / total);
        }
      },
    );

    result.fold(
      (failure) {
        AppModal.error(
          title: 'Upload Failed',
          message: failure.message,
        );
      },
      (user) {
        _authController.user.value = user;

        // Use toast for avatar upload (quick, non-blocking feedback)
        AppToast.success('Avatar uploaded successfully');
        Get.back(); // Go back to previous page
      },
    );

    isLoading.value = false;
    uploadProgress.value = 0.0;
  }

  /// Delete avatar
  Future<void> deleteAvatar() async {
    // Ask for confirmation first
    final confirmed = await AppModal.confirm(
      title: 'Delete Avatar',
      message: 'Are you sure you want to remove your profile picture?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirmed != true) return;

    isLoading.value = true;

    final result = await _authRepo.deleteAvatar();

    result.fold(
      (failure) {
        AppModal.error(
          title: 'Delete Failed',
          message: failure.message,
        );
      },
      (user) {
        _authController.user.value = user;

        // Use toast for delete confirmation (quick feedback)
        AppToast.success('Avatar removed successfully');
      },
    );

    isLoading.value = false;
  }
}
