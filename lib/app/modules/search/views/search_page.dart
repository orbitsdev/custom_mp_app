import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/search/controllers/search_controller.dart';
import 'package:custom_mp_app/app/modules/search/widgets/search_history_section.dart';
import 'package:custom_mp_app/app/modules/search/widgets/search_suggestions_section.dart';
import 'package:custom_mp_app/app/modules/search/widgets/instant_search_results.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

/// Stage 1: Search Page
///
/// Shows:
/// - Search input field
/// - Search history (when empty)
/// - Search suggestions (when empty)
/// - Instant results (when typing)
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = ProductSearchController.instance;
  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    Future.delayed(Duration(milliseconds: 300), () {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.brand,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: _buildSearchField(),
      ),
      body: Obx(() {
        final query = searchController.searchQuery.value;

        // Show instant results when typing
        if (query.isNotEmpty) {
          return InstantSearchResults(query: query);
        }

        // Show history and suggestions when empty using CustomScrollView
        return CustomScrollView(
          slivers: [
            // Search History
            SliverToBoxAdapter(
              child: SearchHistorySection(),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Divider(height: 32, thickness: 8, color: AppColors.brandBackground),
            ),

            // Search Suggestions (Sliver-based)
            SearchSuggestionsSection(),
          ],
        );
      }),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: textController,
        focusNode: focusNode,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search for products...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.brand,
            size: 20,
          ),
          suffixIcon: Obx(() {
            if (searchController.searchQuery.value.isEmpty) {
              return SizedBox.shrink();
            }
            return IconButton(
              icon: Icon(Icons.clear, size: 20, color: Colors.grey),
              onPressed: () {
                textController.clear();
                searchController.clearSearch();
              },
            );
          }),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          searchController.onSearchChanged(value);
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            searchController.executeSearch(value.trim());
          }
        },
      ),
    );
  }
}
