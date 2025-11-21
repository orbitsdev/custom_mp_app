import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';

import 'package:sliver_tools/sliver_tools.dart';
import 'package:gap/gap.dart';

class OpPackageSkeleton extends StatelessWidget {
  const OpPackageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(height: 20, width: 140),
            const Gap(10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                3,
                (_) => ShimmerWidget(
                  height: 40,
                  width: 120,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
