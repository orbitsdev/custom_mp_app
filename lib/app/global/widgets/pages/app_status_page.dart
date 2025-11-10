import 'package:custom_mp_app/app/global/widgets/lottie/app_lottie.dart';
import 'package:flutter/material.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';


class AppStatusPage extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onRetry;
  final String lottieAsset;

  const AppStatusPage({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = 'Retry',
    this.onRetry,
    this.lottieAsset = AppLotties.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLottie(asset: lottieAsset, width: 220, height: 220),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                    ),
              ),
              const SizedBox(height: 24),
              if (onRetry != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                  ),
                  onPressed: onRetry,
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
