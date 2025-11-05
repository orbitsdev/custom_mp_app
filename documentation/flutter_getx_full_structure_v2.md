# 🏗️ Full Folder & File Structure – Flutter E-Commerce App (GetX Clean Architecture)

This markdown provides a **complete directory tree** showing every folder and file used in a **large, production-grade Flutter + GetX e-commerce app**.

You can use this as a **starter base** for scalable and modular projects.

---

## 📂 Full Project Structure

```
lib/
 ├── main.dart
 ├── main_dev.dart
 │
 ├── app/
 │    ├── core/
 │    │    ├── bindings/
 │    │    │     └── app_binding.dart
 │    │    ├── config/
 │    │    │     ├── constants.dart
 │    │    │     ├── theme.dart
 │    │    │     ├── colors.dart
 │    │    │     ├── typography.dart
 │    │    │     ├── env.dart
 │    │    │     └── languages/
 │    │    │           ├── en_US.dart
 │    │    │           ├── tl_PH.dart
 │    │    │           ├── ar_SA.dart
 │    │    │           └── translations.dart
 │    │    ├── routes/
 │    │    │     ├── app_pages.dart
 │    │    │     └── app_routes.dart
 │    │    ├── services/
 │    │    │     ├── api_service.dart
 │    │    │     ├── storage_service.dart
 │    │    │     ├── notification_service.dart
 │    │    │     ├── payment_service.dart
 │    │    │     ├── analytics_service.dart
 │    │    │     ├── localization_service.dart
 │    │    │     └── dialog_service.dart
 │    │    ├── utils/
 │    │    │     ├── formatters.dart
 │    │    │     ├── validators.dart
 │    │    │     ├── helpers.dart
 │    │    │     ├── extensions.dart
 │    │    │     └── logger.dart
 │    │    └── plugins/
 │    │          ├── dio/
 │    │          │     ├── dio_client.dart
 │    │          │     ├── dio_interceptor.dart
 │    │          │     └── dio_error_handler.dart
 │    │          ├── database/
 │    │          │     ├── hive_service.dart
 │    │          │     ├── sqflite_service.dart
 │    │          │     └── local_storage_keys.dart
 │    │          ├── firebase/
 │    │          │     ├── firebase_auth_service.dart
 │    │          │     ├── firebase_messaging_service.dart
 │    │          │     └── firebase_analytics_service.dart
 │    │          ├── video/
 │    │          │     └── video_player_service.dart
 │    │          ├── payment/
 │    │          │     ├── stripe_service.dart
 │    │          │     └── paypal_service.dart
 │    │          └── storage/
 │    │                └── get_storage_service.dart
 │    ├── data/
 │    │    ├── models/
 │    │    │     ├── user/
 │    │    │     │     ├── user_model.dart
 │    │    │     │     └── address_model.dart
 │    │    │     ├── product/
 │    │    │     │     ├── product_model.dart
 │    │    │     │     ├── category_model.dart
 │    │    │     │     └── review_model.dart
 │    │    │     ├── cart/
 │    │    │     │     ├── cart_item_model.dart
 │    │    │     │     └── cart_summary_model.dart
 │    │    │     ├── order/
 │    │    │     │     ├── order_model.dart
 │    │    │     │     └── order_item_model.dart
 │    │    │     ├── notification/
 │    │    │     │     └── notification_model.dart
 │    │    │     ├── common/
 │    │    │     │     ├── base_response.dart
 │    │    │     │     ├── pagination_model.dart
 │    │    │     │     ├── enums.dart
 │    │    │     │     └── typedefs.dart
 │    │    │     └── index.dart
 │    │    ├── providers/
 │    │    │     ├── remote_api_provider.dart
 │    │    │     ├── local_db_provider.dart
 │    │    │     └── cache_provider.dart
 │    │    └── repositories/
 │    │          ├── auth_repository.dart
 │    │          ├── user_repository.dart
 │    │          ├── product_repository.dart
 │    │          ├── cart_repository.dart
 │    │          ├── order_repository.dart
 │    │          └── notification_repository.dart
 │    ├── global/
 │    │    ├── controllers/
 │    │    │     ├── auth_controller.dart
 │    │    │     ├── cart_controller.dart
 │    │    │     ├── notification_controller.dart
 │    │    │     └── theme_controller.dart
 │    │    ├── widgets/
 │    │    │     ├── buttons/
 │    │    │     │     ├── primary_button.dart
 │    │    │     │     ├── secondary_button.dart
 │    │    │     │     └── icon_button.dart
 │    │    │     ├── forms/
 │    │    │     │     ├── input_field.dart
 │    │    │     │     ├── password_field.dart
 │    │    │     │     └── search_field.dart
 │    │    │     ├── modals/
 │    │    │     │     ├── confirm_dialog.dart
 │    │    │     │     ├── success_dialog.dart
 │    │    │     │     ├── error_dialog.dart
 │    │    │     │     ├── info_dialog.dart
 │    │    │     │     ├── loading_dialog.dart
 │    │    │     │     ├── bottom_sheet_modal.dart
 │    │    │     │     └── custom_modal_service.dart
 │    │    │     ├── custom_app_bar.dart
 │    │    │     ├── custom_textfield.dart
 │    │    │     ├── shimmer_skeleton.dart
 │    │    │     └── error_view.dart
 │    │    └── mixins/
 │    │          ├── form_mixin.dart
 │    │          └── loading_state_mixin.dart
 │    ├── modules/
 │    │    ├── splash/
 │    │    │     ├── splash_binding.dart
 │    │    │     ├── splash_controller.dart
 │    │    │     └── splash_view.dart
 │    │    ├── auth/
 │    │    │     ├── auth_binding.dart
 │    │    │     ├── auth_controller.dart
 │    │    │     ├── login_view.dart
 │    │    │     ├── signup_view.dart
 │    │    │     └── forgot_password_view.dart
 │    │    ├── home/
 │    │    │     ├── home_binding.dart
 │    │    │     ├── home_controller.dart
 │    │    │     ├── home_view.dart
 │    │    │     └── widgets/
 │    │    │           ├── banner_slider.dart
 │    │    │           ├── category_list.dart
 │    │    │           └── product_grid.dart
 │    │    ├── product/
 │    │    │     ├── product_binding.dart
 │    │    │     ├── product_controller.dart
 │    │    │     ├── product_list_view.dart
 │    │    │     ├── product_detail_view.dart
 │    │    │     └── widgets/
 │    │    │           ├── product_card.dart
 │    │    │           ├── product_review_list.dart
 │    │    │           └── product_image_slider.dart
 │    │    ├── cart/
 │    │    │     ├── cart_binding.dart
 │    │    │     ├── cart_controller.dart
 │    │    │     ├── cart_view.dart
 │    │    │     └── widgets/
 │    │    │           ├── cart_item_tile.dart
 │    │    │           ├── cart_summary_tile.dart
 │    │    │           └── coupon_modal.dart
 │    │    ├── checkout/
 │    │    │     ├── checkout_binding.dart
 │    │    │     ├── checkout_controller.dart
 │    │    │     ├── checkout_view.dart
 │    │    │     └── widgets/
 │    │    │           ├── address_modal.dart
 │    │    │           ├── payment_option_modal.dart
 │    │    │           └── order_summary_card.dart
 │    │    ├── order/
 │    │    │     ├── order_binding.dart
 │    │    │     ├── order_controller.dart
 │    │    │     ├── order_list_view.dart
 │    │    │     ├── order_detail_view.dart
 │    │    │     └── widgets/
 │    │    │           ├── order_card.dart
 │    │    │           └── order_timeline.dart
 │    │    ├── profile/
 │    │    │     ├── profile_binding.dart
 │    │    │     ├── profile_controller.dart
 │    │    │     ├── profile_view.dart
 │    │    │     └── widgets/
 │    │    │           ├── profile_header.dart
 │    │    │           └── address_list.dart
 │    │    ├── notification/
 │    │    │     ├── notification_binding.dart
 │    │    │     ├── notification_controller.dart
 │    │    │     ├── notification_view.dart
 │    │    │     └── widgets/
 │    │    │           ├── notification_tile.dart
 │    │    │           └── notification_badge.dart
 │    │    └── settings/
 │    │          ├── settings_binding.dart
 │    │          ├── settings_controller.dart
 │    │          └── settings_view.dart
 │    └── widgets/
 │          ├── bottom_nav_bar.dart
 │          ├── search_field.dart
 │          ├── price_tag.dart
 │          ├── quantity_selector.dart
 │          └── empty_state.dart
 └── generated/
      └── ...
assets/
 ├── images/
 │     ├── icons/
 │     └── banners/
 ├── fonts/
 │     └── Poppins/
 ├── lottie/
 │     ├── success.json
 │     ├── error.json
 │     ├── loading.json
 │     └── confirm.json
 └── lang/
       ├── en_US.json
       ├── tl_PH.json
       └── ar_SA.json
```

---

📘 Maintained by: SKSU Project Team  
📅 Last Updated: 2025-10-29
