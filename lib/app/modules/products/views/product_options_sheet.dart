import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';

class ProductOptionsSheet extends StatelessWidget {
  const ProductOptionsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              /// ===========================
              /// 📜 SCROLLABLE CONTENT
              /// ===========================
              SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ==== Handle Bar ====
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),

                    /// ==== Product Info ====
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "https://cdn-icons-png.flaticon.com/512/768/768818.png",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fresh Young Coconut",
                                style: Get.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₱62.00",
                                style: Get.textTheme.headlineSmall!.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// ==== Options ====
                    Text("Available In",
                        style: Get.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      children: [
                        _optionChip("Easy Opened", true),
                        _optionChip("With Husk", false),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text("Colour",
                        style: Get.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _imageOption("Carbon"),
                          _imageOption("Silver"),
                          _imageOption("Black"),
                          _imageOption("Purple"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// ===========================
              /// 📌 FIXED BOTTOM BAR
              /// ===========================
             Positioned(
  left: 0,
  right: 0,
  bottom: 0,
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Quantity Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _qtyButton(Icons.remove),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "1",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _qtyButton(Icons.add),
          ],
        ),

        const SizedBox(height: 18),

        /// FULL-WIDTH ADD TO CART BUTTON
        SizedBox(
          width: double.infinity,
          height: 52,
          child: GradientElevatedButton.icon(
            style: GRADIENT_ELEVATED_BUTTON_STYLE,
            onPressed: () => Get.back(),
            icon: const Icon(
              FluentIcons.cart_16_regular,
              color: Colors.white,
              size: 22,
            ),
            label: Text(
              "Add to Cart",
              style: Get.textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
)

            ],
          ),
        );
      },
    );
  }

  /// OPTION CHIP
  Widget _optionChip(String text, bool selected) {
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      selectedColor: AppColors.brand.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.brandDark : Colors.black87,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected ? AppColors.brand : Colors.grey.shade300,
      ),
    );
  }

  /// SMALL IMAGE OPTION (like Shopee/Lazada)
  Widget _imageOption(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              "https://cdn-icons-png.flaticon.com/512/768/768818.png",
              width: 60,
              height: 60,
            ),
          ),
          const SizedBox(height: 4),
          Text(text,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: () {},
      ),
    );
  }
}
