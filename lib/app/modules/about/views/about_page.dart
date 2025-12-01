import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/utils/path_helpers.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_image.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_image_full_screen_display.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        backgroundColor: AppColors.brand,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(HeroIcons.arrowLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'About Us',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Company Overview Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ABOUT ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'AVANTE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brand,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'AGRI',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Gap(16),
                  Text(
                    'AVANTE AGRI-PRODUCTS PHILIPPINES, INC. or "Avante" for short, emanated from a Latin word which means to say To Progress, To Go Forward or To be Infront.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  Gap(12),
                  Text(
                    'Incorporated on April 14th, 2011 with assigned SEC Registration No. CS201128986 to develop and deliver banana supply from the Philippines to both international and domestic markets the core value of business in the most professional and honest way as possible.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  Gap(12),
                  Text(
                    'The organization is ambitioning to consistently implement and deliver the core-etiquette value of the trade on the table that would later command a lasting business together with goodwill and satisfaction between the company and business associates and partners in the industry.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  Gap(20),
                  // Company Image - Tap to view full screen
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => LocalImageFullScreenDisplay(
                          imageUrl: PathHelpers.imagePath('AVANTE-AGRI.jpg'),
                        ),
                        transition: Transition.fade,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LocalImage(
                          imageUrl: PathHelpers.imagePath('AVANTE-AGRI.jpg'),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Gap(16),
                  Center(
                    child: Text(
                      'Tap image to view full screen',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Mission, Vision & Values Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'OUR ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'MISSION & VALUES',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brand,
                        ),
                      ),
                    ],
                  ),
                  Gap(20),
                  _buildValueCard(
                    icon: HeroIcons.sparkles,
                    title: 'Corporate Spirituality',
                    content:
                        'We derive our strength as company from God or Allah who gives us the kind of HEART that we ought to have: Humble, Ernest, Appreciative, Responsible & Tender.',
                  ),
                  Gap(16),
                  _buildValueCard(
                    icon: HeroIcons.heart,
                    title: 'Customer Care',
                    content:
                        'We care to contribute value to our customers by providing best quality products in relation to price.',
                  ),
                  Gap(16),
                  _buildValueCard(
                    icon: HeroIcons.userGroup,
                    title: 'People Welfare',
                    content:
                        'We regard our people as the best asset to upkeep giving due respect for professional and personal growth & development.',
                  ),
                  Gap(16),
                  _buildValueCard(
                    icon: HeroIcons.shieldCheck,
                    title: 'Accountability & Integrity',
                    content: 'We walk the talk and do what we say.',
                  ),
                  Gap(16),
                  _buildValueCard(
                    icon: HeroIcons.bolt,
                    title: 'Drive to Arrive',
                    content:
                        'We find ways to be efficient and effective in doing the right things done the right way to be ahead on time.',
                  ),
                  Gap(16),
                  _buildValueCard(
                    icon: HeroIcons.globeAlt,
                    title: 'Sustainable Development',
                    content:
                        'We take full responsibility for the impact of our operation on the environment and society.',
                  ),
                ],
              ),
            ),
          ),

          // App Info Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'APP INFORMATION',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  Gap(16),
                  _buildInfoRow('Version', '1.0.0'),
                  Gap(8),
                  _buildInfoRow('Build', '100'),
                  Gap(8),
                  _buildInfoRow('Developer', 'Avante Agri-Products Philippines'),
                ],
              ),
            ),
          ),

          // Legal Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEGAL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  Gap(16),
                  _buildLegalLink(
                    icon: HeroIcons.shieldCheck,
                    title: 'Privacy Policy',
                    onTap: () => Get.toNamed(Routes.privacyPolicyPage),
                  ),
                  Gap(12),
                  _buildLegalLink(
                    icon: HeroIcons.documentText,
                    title: 'Terms of Use',
                    onTap: () => Get.toNamed(Routes.termsOfUsePage),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: Gap(24)),
        ],
      ),
    );
  }

  Widget _buildValueCard({
    required HeroIcons icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.brand.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: HeroIcon(
              icon,
              size: 20,
              color: AppColors.brand,
            ),
          ),
          Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Gap(6),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalLink({
    required HeroIcons icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            HeroIcon(
              icon,
              size: 20,
              color: AppColors.brand,
            ),
            Gap(12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            HeroIcon(
              HeroIcons.chevronRight,
              size: 20,
              color: Colors.grey[400]!,
            ),
          ],
        ),
      ),
    );
  }
}
