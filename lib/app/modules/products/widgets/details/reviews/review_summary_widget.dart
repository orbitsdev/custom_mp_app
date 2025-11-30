import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/reviews/review_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';

class ReviewSummaryWidget extends StatelessWidget {
  final ReviewSummaryModel summary;

  const ReviewSummaryWidget({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Left side: Average rating
          _buildAverageRating(),

          const SizedBox(width: 24),

          // Right side: Rating distribution
          Expanded(child: _buildRatingDistribution()),
        ],
      ),
    );
  }

  Widget _buildAverageRating() {
    return Column(
      children: [
        Text(
          summary.averageRating.toStringAsFixed(1),
          style: Get.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        _buildStars(summary.averageRating),
        const SizedBox(height: 4),
        Text(
          '${summary.totalReviews} ${summary.totalReviews == 1 ? 'review' : 'reviews'}',
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? FluentIcons.star_24_filled
              : FluentIcons.star_24_regular,
          color: AppColors.gold,
          size: 16,
        );
      }),
    );
  }

  Widget _buildRatingDistribution() {
    return Column(
      children: [
        _buildRatingBar(5, summary.ratingDistribution.fiveStar),
        const SizedBox(height: 4),
        _buildRatingBar(4, summary.ratingDistribution.fourStar),
        const SizedBox(height: 4),
        _buildRatingBar(3, summary.ratingDistribution.threeStar),
        const SizedBox(height: 4),
        _buildRatingBar(2, summary.ratingDistribution.twoStar),
        const SizedBox(height: 4),
        _buildRatingBar(1, summary.ratingDistribution.oneStar),
      ],
    );
  }

  Widget _buildRatingBar(int stars, int count) {
    final percentage = summary.ratingDistribution.getPercentage(
      stars,
      summary.totalReviews,
    );

    return Row(
      children: [
        // Star number
        SizedBox(
          width: 12,
          child: Text(
            '$stars',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          FluentIcons.star_24_filled,
          color: AppColors.gold,
          size: 12,
        ),
        const SizedBox(width: 8),

        // Progress bar
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Count
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
