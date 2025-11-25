import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image_full_screen_display.dart';
import 'package:custom_mp_app/app/global/widgets/wrapper/ripple_cotainer.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class ProfileUpdatePage extends StatelessWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        backgroundColor: AppColors.brandDark,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final user = authController.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            // Avatar Section
            GestureDetector(
              onTap: () => Get.to(()=> OnlineImageFullScreenDisplay(imageUrl: user.profilePhotoUrl)),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                          
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.profilePhotoUrl),
                      backgroundColor: AppColors.brandBackground,
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.uploadAvatarPage);
                      },
                      icon: const HeroIcon(HeroIcons.camera, style: HeroIconStyle.solid, size: 20, ),
                      label: const Text('Change Avatar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Basic Information Section
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildListTile(
                    icon: Icons.person_outline,
                    title: 'Name',
                    subtitle: user.name,
                    onTap: () {
                      Get.toNamed(
                        Routes.updateFieldPage,
                        arguments: {
                          'field': 'name',
                          'title': 'Update Name',
                          'currentValue': user.name,
                        },
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.brandBackground,),
                  _buildListTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: user.email,
                    onTap: () {
                      Get.toNamed(
                        Routes.updateFieldPage,
                        arguments: {
                          'field': 'email',
                          'title': 'Update Email',
                          'currentValue': user.email,
                        },
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.brandBackground,),
                  _buildListTile(
                    icon: Icons.lock_outline,
                    title: 'Password',
                    subtitle: '••••••••',
                    onTap: () {
                      Get.toNamed(Routes.updatePasswordPage);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Account Information Section
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildListTile(
                    icon: Icons.badge_outlined,
                    title: 'Full Name',
                    subtitle: user.accountInformation?.fullName ?? 'Not set',
                    onTap: () {
                      Get.toNamed(Routes.updateAccountInfoPage);
                    },
                  ),
                  const Divider(height: 1, color: AppColors.brandBackground,),
                  _buildListTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    subtitle: user.accountInformation?.phoneNumber ?? 'Not set',
                    onTap: () {
                      Get.toNamed(Routes.updateAccountInfoPage);
                    },
                  ),
                  const Divider(height: 1, color: AppColors.brandBackground,),
                  _buildListTile(
                    icon: Icons.wc_outlined,
                    title: 'Gender',
                    subtitle: user.accountInformation?.gender.capitalizeFirst ?? 'Not set',
                    onTap: () {
                      Get.toNamed(Routes.updateAccountInfoPage);
                    },
                  ),
                  const Divider(height: 1, color: AppColors.brandBackground,),
                  // _buildListTile(
                  //   icon: Icons.cake_outlined,
                  //   title: 'Date of Birth',
                  //   subtitle: user.accountInformation?.formattedDate ?? 'Not set',
                  //   onTap: () {
                  //     Get.toNamed(Routes.updateAccountInfoPage);
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brand),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
