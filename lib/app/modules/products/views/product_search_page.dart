import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';


class ProductSearchPage extends StatelessWidget {
  const ProductSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Find Your Favorites', style: Get.textTheme.titleLarge?.copyWith(color: Colors.white),),
            backgroundColor: AppColors.brandDark,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            pinned: true,
            floating: true,
          ),
          ToSliver(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.brandDark,
              ),
              padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 8 ),
              child: TextField(
                autofocus: true,
                // controller: searchController.textController,
                style: Get.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search...',
                  hintStyle: Get.textTheme.bodyMedium,
                  prefixIcon: Container(
                    
                    child: HeroIcon(HeroIcons.magnifyingGlass, size: 24,color: AppColors.brandDark,)),
                  suffixIcon: 
                       IconButton(
                          // onPressed: searchController.clearSearch,
                          onPressed: (){

                          },
                          icon: Icon(Icons.close, size: 16,),
                        )
                      ,
                  // suffixIcon: searchController.searchText.value.trim().isNotEmpty
                  //     ? IconButton(
                  //         onPressed: searchController.clearSearch,
                  //         icon: Icon(Icons.close, size: 16,),
                  //       )
                  //     : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          ToSliver(
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    color: AppColors.brandDark,
                  ),
                ),
          // GetBuilder<SearchBarController>(
          //   builder: (controller) {
          //     if (controller.isSearchLoading.value ||
          //         controller.isRandomProductsIsLoading.value ||
          //         controller.isRelatedProductLoading.value) {
          //       return ToSliver(
          //         child: LinearProgressIndicator(
          //           minHeight: 2,
          //           color: AppColors.brandDark,
          //         ),
          //       );
          //     } else {
          //       return ToSliver(
          //         child: Container(height: 2),
          //       );
          //     }
          //   },
          // ),
          // GetBuilder<SearchBarController>(
          //   builder: (controller) {
          //     if (controller.searchText.value.isEmpty) {
          //       return SearchPopularProductVerticalList(
          //           searchTextValue: searchController.searchText.value,
          //           results: searchController.results,
          //           selectProduct: controller.gotToProductDetails,
          //         );
                
          //     } else if (controller.searchText.value.isNotEmpty) {
          //       return SearchPopularProductVerticalList(
          //         searchTextValue: searchController.searchText.value,
          //         results: searchController.results,
          //         selectProduct: controller.gotToProductDetails,
          //       );
          //     } else {
          //       return ToSliver(
          //         child: Center(
          //           child: LocalLottieImage(
          //             imagePath: 'assets/lotties/search.json',
          //             width: 200,
          //             height: 200,
          //           ),
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
