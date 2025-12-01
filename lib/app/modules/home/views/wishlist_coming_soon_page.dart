import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class WishlistComingSoonPage extends StatelessWidget {
  const WishlistComingSoonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Heart Icon with gradient background
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.brand.withOpacity(0.1),
                        AppColors.brandLight.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: HeroIcon(
                      HeroIcons.heart,
                      size: 60,
                      color: AppColors.brand,
                      style: HeroIconStyle.outline,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Coming Soon Text
                Text(
                  'Coming Soon',
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  'We\'re working on something amazing!\nThe Wishlist feature will be available soon.',
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Decorative dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(AppColors.brand),
                    const SizedBox(width: 8),
                    _buildDot(AppColors.brand.withOpacity(0.6)),
                    const SizedBox(width: 8),
                    _buildDot(AppColors.brand.withOpacity(0.3)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
