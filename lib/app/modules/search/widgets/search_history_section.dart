import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/search/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

/// Search History Section
///
/// Shows recent search queries with ability to:
/// - Click to search again
/// - Delete individual items
/// - Clear all history
class SearchHistorySection extends StatelessWidget {
  const SearchHistorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ProductSearchController.instance;

    return Obx(() {
      if (controller.searchHistory.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    HeroIcon(
                      HeroIcons.clock,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    Gap(8),
                    Text(
                      'Recent Searches',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    final confirmed = await AppModal.confirm(
                      title: 'Clear History?',
                      message: 'This will remove all your search history.',
                      confirmText: 'Clear',
                      cancelText: 'Cancel',
                    );

                    if (confirmed == true) {
                      controller.clearHistory();
                    }
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            Gap(12),

            // History Items - Wrap with chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.searchHistory.take(10).map((query) {
                return _buildHistoryChip(query, controller);
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  /// Build gray chip/badge for history item
  Widget _buildHistoryChip(String query, ProductSearchController controller) {
    return InkWell(
      onTap: () {
        controller.executeSearch(query);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              query,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(6),
            GestureDetector(
              onTap: () {
                controller.removeHistoryItem(query);
              },
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
