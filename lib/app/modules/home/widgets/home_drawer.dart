
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/utils/path_helpers.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_image.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/home/widgets/tbi_signature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        color: Colors.white, // Background color for the drawer
        child: Column(
          children: [
            // App Logo and Name
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orangeAccent, // Matches your app's color scheme
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    // Icon(
                    //   Icons.shopping_cart, // Replace with your actual app logo image
                    //   size: 50,
                    //   color: Colors.white,
                    // ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: LocalImage(imageUrl: PathHelpers.imagePath('logo.png'))),
                    SizedBox(height: 8),
                    // App Name
                    Text(
                      'Avante Foods ',
                      style: Get.textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Drawer Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.search, color: Colors.orangeAccent),
                    title: Text(
                      'Search Products',
                      style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      Get.back(); // Close drawer
                      Get.toNamed(Routes.searchPage);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.category, color: Colors.orangeAccent),
                    title: Text(
                      'Categories',
                      style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.allCategoriesPage);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite_border, color: Colors.orangeAccent),
                    title: Text(
                      'Favorites',
                      style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black87),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Soon',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      Get.snackbar(
                        'Coming Soon',
                        'Favorites feature will be available soon!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.brand,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(16),
                      );
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.orangeAccent),
                    title: Text(
                      'About Us',
                      style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.aboutPage);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.orangeAccent),
                    title: Text(
                      'Help & Support',
                      style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.helpSupportPage);
                    },
                  ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _handleLogout(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                ),
              ),
            ),

            TbiSignature(),
          ],
        ),
      ),
    );
  }

  // Handle logout with confirmation
  Future<void> _handleLogout(BuildContext context) async {
    Get.back(); // Close drawer first

    final shouldLogout = await AppModal.confirm(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
    );

    if (shouldLogout == true) {
      final authController = Get.find<AuthController>();
      await authController.logout();
    }
  }

}
