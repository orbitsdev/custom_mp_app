import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';

import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class OpSummarySkeleton extends StatelessWidget {
  const OpSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding:  EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children:  [
            _SkeletonRow(),
            SizedBox(height: 12),
            _SkeletonRow(),
            SizedBox(height: 12),
            _SkeletonRow(),
            SizedBox(height: 16),

            // same divider spacing
            ShimmerWidget(width: double.infinity, height: 2),

            SizedBox(height: 16),
            _SkeletonRow(),
          ],
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        ShimmerWidget(width: 120, height: 16),
        ShimmerWidget(width: 70, height: 16),
      ],
    );
  }
}
