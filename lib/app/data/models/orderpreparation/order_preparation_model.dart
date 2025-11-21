// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final int? selectedShippingAddressId;

  OrderPreparationModel({
    required this.cartItems,
    required this.packages,
    required this.shippingAddresses,
    required this.summary,
    required this.selectedPackageId,
    required this.selectedShippingAddressId,
  });

  //from map
  factory OrderPreparationModel.fromMap(Map<String, dynamic> map) {
    return OrderPreparationModel(
      cartItems: List<CartItemModel>.from(
        map['cart_items']?.map((x) => CartItemModel.fromMap(x)),
      ),
      packages: List<OrderPackageModel>.from(
        map['packages']?.map((x) => OrderPackageModel.fromMap(x)),
      ),
      shippingAddresses: List<ShippingAddressModel>.from(
        map['shipping_addresses']?.map((x) => ShippingAddressModel.fromMap(x)),
      ),
      summary: OrderPreparationSummaryModel.fromMap(map['summary']),
      selectedPackageId: map['selected_package_id'],
      selectedShippingAddressId: map['selected_shipping_address_id'],
    );
  }
OrderPreparationModel copyWith({
  List<CartItemModel>? cartItems,
  List<OrderPackageModel>? packages,
  List<ShippingAddressModel>? shippingAddresses,
  OrderPreparationSummaryModel? summary,
  int? selectedPackageId,
  int? selectedShippingAddressId,
}) {
  return OrderPreparationModel(
    cartItems: cartItems ?? this.cartItems,
    packages: packages ?? this.packages,
    shippingAddresses: shippingAddresses ?? this.shippingAddresses,
    summary: summary ?? this.summary,
    selectedPackageId: selectedPackageId ?? this.selectedPackageId,
    selectedShippingAddressId:
        selectedShippingAddressId ?? this.selectedShippingAddressId,
  );
}



  @override
  String toString() {
    return 'OrderPreparationModel(cartItems: $cartItems, packages: $packages, shippingAddresses: $shippingAddresses, summary: $summary, selectedPackageId: $selectedPackageId, selectedShippingAddressId: $selectedShippingAddressId)';
  }
}
