import 'package:flutter/material.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/reviews/review_card_skeleton.dart';

/// Skeleton loader for reviews list
class ReviewsListSkeleton extends StatelessWidget {
  final int itemCount;

  const ReviewsListSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const ReviewCardSkeleton(),
    );
  }
}
