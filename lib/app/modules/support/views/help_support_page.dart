import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

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
          'Help & Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Contact Support Section
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
                    'CONTACT US',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                      letterSpacing: 1,
                    ),
                  ),
                  Gap(16),
                  Text(
                    'Need help? Our support team is here to assist you.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  Gap(24),
                  _buildContactCard(
                    icon: HeroIcons.envelope,
                    title: 'Email Support',
                    content: 'support@avantefoods.com',
                    onTap: () => _copyToClipboard('support@avantefoods.com', 'Email'),
                  ),
                  Gap(12),
                  _buildContactCard(
                    icon: HeroIcons.phone,
                    title: 'Phone Support',
                    content: '+63 XXX XXX XXXX',
                    onTap: () => _copyToClipboard('+63 XXX XXX XXXX', 'Phone number'),
                  ),
                  Gap(12),
                  _buildContactCard(
                    icon: HeroIcons.mapPin,
                    title: 'Visit Us',
                    content: 'Avante Agri-Products Philippines, Inc.\nPhilippines',
                    onTap: null,
                  ),
                ],
              ),
            ),
          ),

          // FAQ Section
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
                    'FREQUENTLY ASKED QUESTIONS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                      letterSpacing: 1,
                    ),
                  ),
                  Gap(20),
                  _buildFAQItem(
                    question: 'How do I track my order?',
                    answer:
                        'Go to Profile > My Orders to view all your orders and their current status.',
                  ),
                  Gap(16),
                  _buildFAQItem(
                    question: 'What payment methods do you accept?',
                    answer:
                        'We accept Cash on Delivery, GCash, and major credit/debit cards.',
                  ),
                  Gap(16),
                  _buildFAQItem(
                    question: 'How long does delivery take?',
                    answer:
                        'Delivery typically takes 3-5 business days depending on your location.',
                  ),
                  Gap(16),
                  _buildFAQItem(
                    question: 'Can I cancel my order?',
                    answer:
                        'Yes, you can cancel unpaid orders anytime. For paid orders, please contact support.',
                  ),
                ],
              ),
            ),
          ),

          // Business Hours
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
                    'BUSINESS HOURS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  Gap(16),
                  _buildInfoRow('Monday - Friday', '8:00 AM - 5:00 PM'),
                  Gap(8),
                  _buildInfoRow('Saturday', '9:00 AM - 12:00 PM'),
                  Gap(8),
                  _buildInfoRow('Sunday', 'Closed'),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: Gap(24)),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required HeroIcons icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.brandBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Gap(4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
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

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Gap(8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
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

  void _copyToClipboard(String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied!',
      '$type copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: AppColors.brand,
      colorText: Colors.white,
    );
  }
}
