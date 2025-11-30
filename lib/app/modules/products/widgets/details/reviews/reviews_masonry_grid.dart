import 'package:custom_mp_app/app/data/models/reviews/review_model.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/reviews/review_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// TRUE Masonry grid for review cards (cards adjust to content height)
class ReviewsMasonryGrid extends StatelessWidget {
  final List<ReviewModel> reviews;
  final int crossAxisCount;

  const ReviewsMasonryGrid({
    Key? key,
    required this.reviews,
    this.crossAxisCount = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return ReviewCardWidget(review: reviews[index]);
      },
    );
  }
}
