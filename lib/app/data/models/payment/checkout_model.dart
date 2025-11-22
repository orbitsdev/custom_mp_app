import 'dart:convert';

class CheckoutModel {
  final String checkoutUrl;
  final String orderReferenceId;
  final String successUrl;
  final String cancelUrl;
  final num totalAmount;
  final num itemsTotal;
  final num packageFee;

  CheckoutModel({
    required this.checkoutUrl,
    required this.orderReferenceId,
    required this.successUrl,
    required this.cancelUrl,
    required this.totalAmount,
    required this.itemsTotal,
    required this.packageFee,
  });

  factory CheckoutModel.fromMap(Map<String, dynamic> map) {
    return CheckoutModel(
      checkoutUrl: map['checkout_url'],
      orderReferenceId: map['order_reference_id'],
      successUrl: map['success_url'],
      cancelUrl: map['cancel_url'],
      totalAmount: map['total_amount'],
      itemsTotal: map['items_total'],
      packageFee: map['package_fee'],
    );
  }
}
