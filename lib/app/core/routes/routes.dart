import 'package:custom_mp_app/app/global/widgets/image/online_image_full_screen_display.dart';
import 'package:custom_mp_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:custom_mp_app/app/modules/auth/middleware/auth_middleware.dart';
import 'package:custom_mp_app/app/modules/auth/middleware/guest_middleware.dart';
import 'package:custom_mp_app/app/modules/auth/views/login_page.dart';
import 'package:custom_mp_app/app/modules/auth/views/signup_page.dart';
import 'package:custom_mp_app/app/modules/auth/views/splash_page.dart';
import 'package:custom_mp_app/app/modules/cart/views/cart_page.dart';
import 'package:custom_mp_app/app/modules/home/bindings/home_binding.dart';
import 'package:custom_mp_app/app/modules/home/views/home_page.dart';
import 'package:custom_mp_app/app/modules/orders/views/orders_page.dart';
import 'package:custom_mp_app/app/modules/orders/views/order_detail_page.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/bindings/order_preparation_binding.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/views/order_preparation_page.dart';
import 'package:custom_mp_app/app/modules/payment/bindings/payment_binding.dart';
import 'package:custom_mp_app/app/modules/payment/views/payment_success_page.dart';
import 'package:custom_mp_app/app/modules/payment/views/payment_page.dart';
import 'package:custom_mp_app/app/modules/products/bindings/product_binding.dart';
import 'package:custom_mp_app/app/modules/products/views/product_details_page.dart';
import 'package:custom_mp_app/app/modules/products/views/product_search_page.dart';
import 'package:custom_mp_app/app/modules/category/bindings/category_products_binding.dart';
import 'package:custom_mp_app/app/modules/category/views/category_products_page.dart';
import 'package:custom_mp_app/app/modules/search/bindings/search_binding.dart';
import 'package:custom_mp_app/app/modules/search/views/search_page.dart';
import 'package:custom_mp_app/app/modules/search/views/search_results_page.dart';
import 'package:custom_mp_app/app/modules/notifications/views/notifications_page.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/bindings/shipping_address_binding.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/views/create_address_page.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/views/psgc_select_page.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/views/shipping_address_page.dart';
import 'package:custom_mp_app/app/modules/myprofile/bindings/profile_update_binding.dart';
import 'package:custom_mp_app/app/modules/myprofile/views/profile_update_page.dart';
import 'package:custom_mp_app/app/modules/myprofile/views/update_field_page.dart';
import 'package:custom_mp_app/app/modules/myprofile/views/update_password_page.dart';
import 'package:custom_mp_app/app/modules/myprofile/views/update_account_info_page.dart';
import 'package:custom_mp_app/app/modules/myprofile/views/upload_avatar_page.dart';
import 'package:custom_mp_app/app/modules/testing/modal_page.dart';
import 'package:get/route_manager.dart';

class Routes {
  //Authentication
  static const String loginPage = '/login';
  static const String signupPage = '/signup';
  static const String forgotPasswordPage = '/home';
  static const String splashPage = '/splash';
  static const String homePage = '/home';

  //PRODUCTS
  static const String productSearchPage = '/product-search';
  static const String productDetailsPage = '/product-details';

  //CATEGORY
  static const String categoryProductsPage = '/category-products';

  //SEARCH
  static const String searchPage = '/search';
  static const String searchResultsPage = '/search-results';

  //NOTIFICATIONS
  static const String notificationsPage = '/notifications';

  //CARTS
  static const String cartPage = '/cart';

  //ORDER PREPRATION
  static const String orderPreparationPage = '/order-preparation';

  //ORDERS
  static const String ordesrPage = '/orders';

  //SHIPPING ADDRESS
  static const String shippingAddressPage = '/shipping-address';
  static const String shippingAddressCreatePage = '/shipping-address-create';
  static const String psgcSelectPage = '/psgc-select';

  //PAYMENT
  static const String paymentPage = '/payment';
  static const String paymentSuccessPage = '/payment-success';


  //ORDERS
  static const String ordersPage = '/orders';
  static const String orderDetailPage = '/order-detail';

  //PROFILE UPDATE
  static const String profileUpdatePage = '/profile-update';
  static const String updateFieldPage = '/update-field';
  static const String updatePasswordPage = '/update-password';
  static const String updateAccountInfoPage = '/update-account-info';
  static const String uploadAvatarPage = '/upload-avatar';

  //TEST IGN
  static const String modalPage = '/modal';

  static List<GetPage> pages = [
    GetPage(name: Routes.splashPage, page: () => const SplashPage()),
    GetPage(name: modalPage, page: () => ModalPage()),
    GetPage(
      name: Routes.loginPage,
      middlewares: [GuestMiddleware()],
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signupPage,
      middlewares: [GuestMiddleware()],
      page: () => SignupPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.homePage,
      middlewares: [AuthMiddleware()],
      page: () => HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.productDetailsPage,
      middlewares: [AuthMiddleware()],
      page: () => ProductDetailsPage(),
      binding: ProductBinding(),
    ),

    GetPage(
      name: Routes.categoryProductsPage,
      middlewares: [AuthMiddleware()],
      page: () => CategoryProductsPage(),
      binding: CategoryProductsBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: Routes.productSearchPage,
      middlewares: [AuthMiddleware()],
      page: () => ProductSearchPage(),
      // binding: HomeBinding()
    ),

    // Search pages
    GetPage(
      name: Routes.searchPage,
      middlewares: [AuthMiddleware()],
      page: () => SearchPage(),
      binding: SearchBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: Routes.searchResultsPage,
      middlewares: [AuthMiddleware()],
      page: () => SearchResultsPage(),
      binding: SearchBinding(), // ← Added binding!
      transition: Transition.cupertino,
    ),

    // Notifications
    GetPage(
      name: Routes.notificationsPage,
      middlewares: [AuthMiddleware()],
      page: () => NotificationsPage(),
      transition: Transition.cupertino,
    ),

    //carts
    GetPage(
      name: Routes.cartPage,
      middlewares: [AuthMiddleware()],
      page: () => CartPage(),
      // binding: HomeBinding()
    ),
    GetPage(
      name: Routes.orderPreparationPage,
      middlewares: [AuthMiddleware()],
      page: () => OrderPreparationPage(),
      binding: OrderPreparationBinding(),
    ),
    GetPage(
      name: Routes.shippingAddressPage,
      middlewares: [AuthMiddleware()],
      page: () => ShippingAddressPage(),
      binding: ShippingAddressBinding(),
    ),

    GetPage(
      name: Routes.shippingAddressCreatePage,
      middlewares: [AuthMiddleware()],
      page: () => const CreateAddressPage(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: Routes.psgcSelectPage,
      page: () =>
          const PSGCSelectPage(level: PSGCLevel.region), // overridden on call
      binding: ShippingAddressBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.paymentPage,
      page: () => const PaymentPage(),
      binding: PaymentBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.paymentSuccessPage,
      middlewares: [AuthMiddleware()],
      page: () => const PaymentSuccessPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.ordesrPage,
      middlewares: [AuthMiddleware()],
      page: () => const OrdersPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.orderDetailPage,
      middlewares: [AuthMiddleware()],
      page: () => const OrderDetailPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.profileUpdatePage,
      middlewares: [AuthMiddleware()],
      page: () => const ProfileUpdatePage(),
      binding: ProfileUpdateBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.updateFieldPage,
      middlewares: [AuthMiddleware()],
      page: () => const UpdateFieldPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.updatePasswordPage,
      middlewares: [AuthMiddleware()],
      page: () => const UpdatePasswordPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.updateAccountInfoPage,
      middlewares: [AuthMiddleware()],
      page: () => const UpdateAccountInfoPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.uploadAvatarPage,
      middlewares: [AuthMiddleware()],
      page: () => const UploadAvatarPage(),
      transition: Transition.cupertino,
    ),


   
  ];
}
