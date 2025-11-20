import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/data/models/orderpreparation/order_package_model.dart';
import 'package:custom_mp_app/app/data/models/orderpreparation/order_summary_model.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/shipping_address_model.dart';

class OrderPreparationModel {
  final List<CartItemModel> cartItems;
  final List<OrderPackageModel> packages;
  final List<ShippingAddressModel> shippingAddresses;
  final OrderPreparationSummaryModel summary;
  final int? selectedPackageId;

  OrderPreparationModel({
    required this.cartItems,
    required this.packages,
    required this.shippingAddresses,
    required this.summary,
    required this.selectedPackageId,
  });

  factory OrderPreparationModel.fromJson(Map<String, dynamic> json) {
    return OrderPreparationModel(
      cartItems: (json['cart_items'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),

      packages: (json['packages'] as List)
          .map((e) => OrderPackageModel.fromJson(e))
          .toList(),

      shippingAddresses: (json['shipping_addresses'] as List)
          .map((e) => ShippingAddressModel.fromJson(e))
          .toList(),

      summary: OrderPreparationSummaryModel.fromJson(json['summary']),

      selectedPackageId: json['selected_package_id'], // can be null
    );
  }
}
