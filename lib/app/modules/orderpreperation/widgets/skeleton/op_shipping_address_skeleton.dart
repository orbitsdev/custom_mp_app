import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';

class OpShippingAddressSkeleton extends StatelessWidget {
  const OpShippingAddressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(height: 18, width: 160),
            const SizedBox(height: 12),
            ShimmerWidget(height: 16, width: 200),
            const SizedBox(height: 8),
            ShimmerWidget(height: 12, width: double.infinity),
            const SizedBox(height: 4),
            ShimmerWidget(height: 12, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
