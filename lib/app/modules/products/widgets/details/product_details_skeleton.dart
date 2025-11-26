import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';

/// Skeleton loader for ProductDetailsPage
/// Mimics the actual page layout for better UX
class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar Skeleton
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          backgroundColor: Colors.white,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ShimmerWidget(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: ShimmerWidget(
              width: double.infinity,
              height: 400,
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),

        // Image Gallery Skeleton
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ShimmerWidget(
                    width: 60,
                    height: 60,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Product Info Skeleton
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                ShimmerWidget(
                  width: double.infinity,
                  height: 24,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),

                // Price
                ShimmerWidget(
                  width: 120,
                  height: 32,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 16),

                // Rating
                Row(
                  children: [
                    ShimmerWidget(
                      width: 100,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 12),
                    ShimmerWidget(
                      width: 60,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Short description lines
                ShimmerWidget(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: 200,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),

        // Tabs Skeleton
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: ShimmerWidget(
                    width: 80,
                    height: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Tab Content Skeleton
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content lines
                ...List.generate(
                  8,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ShimmerWidget(
                      width: index == 7 ? 150 : double.infinity,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}
