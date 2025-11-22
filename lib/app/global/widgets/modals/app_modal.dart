import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/global/widgets/lottie/app_lottie.dart';

import 'package:custom_mp_app/app/core/theme/app_colors.dart';

/// ---------------------------------------------------------------------------
///  AppModal — Global reusable modal system
/// ---------------------------------------------------------------------------
class AppModal {
  /// ✅ SUCCESS MODAL
  static void success({
    String title = 'Success',
    String message = 'Operation completed successfully.',
    String buttonText = 'OK',
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLottie(asset: AppLotties.success, width: 130, height: 130),
              const SizedBox(height: 12),
              Text(
                title,
                style: Get.textTheme.titleLarge?.copyWith(
                  color: AppColors.green, // ✅ success color
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand, // ✅ primary brand color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  Get.back();
                  onConfirm?.call();
                },
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// ❌ ERROR MODAL
  static void error({
    String title = 'Error',
    String message = 'Something went wrong.',
    String buttonText = 'Got it',
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLottie(asset: AppLotties.error, width: 130, height: 130),
              const SizedBox(height: 12),
              Text(
                title,
                style: Get.textTheme.titleLarge?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  Get.back();
                  onConfirm?.call();
                },
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// ⚠️ CONFIRMATION MODAL
  /// Returns Future<bool?> - true if confirmed, false if cancelled, null if dismissed
  static Future<bool?> confirm({
    String title = 'Confirmation',
    String message = 'Are you sure you want to proceed?',
    String confirmText = 'Yes',
    String cancelText = 'No',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = false,
  }) async {
    return await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLottie(asset: AppLotties.confirm, width: 130, height: 130),
              const SizedBox(height: 12),
              Text(
                title,
                style: Get.textTheme.titleLarge?.copyWith(
                  color: AppColors.brandDark, // ✅ darker accent
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.textLight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () {
                        Get.back(result: false);
                        onCancel?.call();
                      },
                      child: Text(cancelText),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () {
                        Get.back(result: true);
                        onConfirm?.call();
                      },
                      child: Text(
                        confirmText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// ⏳ LOADING MODAL
  static void loading({
    String title = 'Please wait...',
    bool barrierDismissible = false,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 
                  CircularProgressIndicator(
                    color: AppColors.brand,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// 🔹 Close any open dialog
  static void close() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

static void info({
  String title = "Information",
  String message = "Here is something important you should know.",
  String buttonText = "OK",
  VoidCallback? onConfirm,
  bool barrierDismissible = true,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔵 Info Icon
            Icon(
              Icons.info_outline,
              size: 80,
              color: AppColors.brand,
            ),
            const SizedBox(height: 12),

            // 🏷 Title
            Text(
              title,
              style: Get.textTheme.titleLarge?.copyWith(
                color: AppColors.brandDark,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // 📄 Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 OK Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () {
                Get.back();
                onConfirm?.call();
              },
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: barrierDismissible,
  );
}
 
}
