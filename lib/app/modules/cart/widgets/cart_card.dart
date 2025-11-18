// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_quantity_button.dart';
import 'package:flutter/material.dart';

import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CartCard extends StatelessWidget {
  CartItemModel cartItem;
  CartCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    bool isOutOfStock = cartItem.variant?.availableStock == 0;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (cartItem.isSelected == true)
            ? AppColors.brandLight
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: AppColors.brand,
                  side: BorderSide(
                    color: isOutOfStock
                        ? AppColors.textLight
                        : AppColors.textLight,
                  ),
                  value: cartItem.isSelected,
                  onChanged: isOutOfStock ? null : (value) {},
                ),
              ),

              Container(
                height: 90,
                width: 110,
                margin: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: OnlineImage(imageUrl: cartItem.variant!.media),
                    ),
                    if (isOutOfStock)
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                              0.7,
                            ), // Semi-transparent background
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            'Out of Stock',
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cartItem.variant?.product.name}',
                      style: Get.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    if (!cartItem.variant!.isDefault)
                      Text(
                        '${cartItem.variant!.name}',
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    const Gap(4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '₱',
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: isOutOfStock
                                  ? AppColors.textLight
                                  : AppColors.brandDark,
                            ),
                            children: [
                              TextSpan(
                                text: '${cartItem.finalPrice}',
                                style: Get.textTheme.bodySmall!.copyWith(
                                  color: isOutOfStock
                                      ? AppColors.textLight
                                      : AppColors.brandDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Stock: ${cartItem.variant!.availableStock}',
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: isOutOfStock
                            ? AppColors.textLight
                            : AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: Get.textTheme.bodySmall!.copyWith(
                            color: isOutOfStock ? AppColors.textLight : null,
                          ),
                        ),
                        Row(
                          children: [
                            CartQuantityButton(
                              disable: isOutOfStock,
                              icon: const Icon(Icons.remove, size: 14),
                              onPressed: isOutOfStock ? null : () {
                                print('descrease quantity');
                              },
                            ),
                            const Gap(4),
                            Container(
                              constraints: BoxConstraints(minWidth: 30),
                              child: Center(
                                child: Text('${cartItem.quantity}',style: Get.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                              ),
                            ),
                            const Gap(4),
                            CartQuantityButton(
                              disable: isOutOfStock,
                              icon: const Icon(Icons.add, size: 14),
                              onPressed: isOutOfStock ? null : () {
                                print('increase quantity');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
