import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/modules/search/controllers/search_controller.dart';
import 'package:custom_mp_app/app/modules/search/widgets/search_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Instant Search Results
///
/// Shows real-time search results as user types
/// Highlights matching text in product names
class InstantSearchResults extends StatelessWidget {
  final String query;

  const InstantSearchResults({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ProductSearchController.instance;

    return Obx(() {
      // Loading state with shimmer
      if (controller.isLoadingInstant.value) {
        return SearchLoadingWidget();
      }

      // No results
      if (controller.instantResults.isEmpty) {
        return _buildEmptyState();
      }

      // Results list - Simple product names only
      return ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: controller.instantResults.length,
        separatorBuilder: (context, index) => Divider(height: 0.5, color: Colors.grey[200]),
        itemBuilder: (context, index) {
          final product = controller.instantResults[index];
          return _buildProductNameItem(product, query);
        },
      );
    });
  }

  /// Simple product name item (no images, just text with highlighting)
  Widget _buildProductNameItem(ProductModel product, String query) {
    return InkWell(
      onTap: () {
        // Save to history when user clicks
        final controller = ProductSearchController.instance;
        controller.executeSearch(query);

        // Navigate to product detail
        Get.toNamed(Routes.productDetailsPage, arguments: product);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Search icon
            Icon(
              Icons.search,
              size: 20,
              color: Colors.grey[400],
            ),
            Gap(12),

            // Product Name with Highlighted Text
            Expanded(
              child: _buildHighlightedText(
                product.name,
                query,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // Arrow icon
            Icon(
              Icons.north_west,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  /// Build text with highlighted matching query
  Widget _buildHighlightedText(
    String text,
    String query, {
    TextStyle? style,
  }) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    // Find all matches
    final matches = <int>[];
    int index = lowerText.indexOf(lowerQuery);
    while (index != -1) {
      matches.add(index);
      index = lowerText.indexOf(lowerQuery, index + 1);
    }

    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    // Build text spans with highlights
    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final matchIndex in matches) {
      // Add text before match
      if (matchIndex > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, matchIndex),
          style: style,
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: style?.copyWith(
              backgroundColor: AppColors.orange.withOpacity(0.3),
              fontWeight: FontWeight.w700,
              color: AppColors.brand,
            ) ??
            TextStyle(
              backgroundColor: AppColors.orange.withOpacity(0.3),
              fontWeight: FontWeight.w700,
              color: AppColors.brand,
            ),
      ));

      currentIndex = matchIndex + query.length;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.brand),
            Gap(16),
            Text(
              'Searching...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[300],
            ),
            Gap(16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Gap(8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
