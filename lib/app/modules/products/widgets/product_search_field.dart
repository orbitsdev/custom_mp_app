
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart' as h;


class ProductSearchField extends StatelessWidget {
  final Function? onSearchTap;
  final Function? onFilterTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductSearchField({
    Key? key,
    this.onSearchTap,
    this.onFilterTap,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Menu Icon wrapped in GestureDetector
        GestureDetector(
          onTap: () {
            // Open the drawer using the scaffoldKey
            scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        Gap(16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (onSearchTap != null) {
                onSearchTap!();
              }
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      color: AppColors.brandBackground,
                    ),
                    child: h.HeroIcon(
                      h.HeroIcons.magnifyingGlass,
                      size: 24,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  Gap(8),
                  Expanded(
                    child: Text(
                      'Search Items ...',
                      style: Get.textTheme.bodyMedium!.copyWith(
                        color: AppColors.lightGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
