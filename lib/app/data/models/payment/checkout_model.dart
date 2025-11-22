class CheckoutModel {
  final String checkoutUrl;
  final String orderReferenceId;
  final String successUrl;
  final String cancelUrl;
  final double totalAmount;

  CheckoutModel({
    required this.checkoutUrl,
    required this.orderReferenceId,
    required this.successUrl,
    required this.cancelUrl,
    required this.totalAmount,
  });

  factory CheckoutModel.fromMap(Map<String, dynamic> map) {
    return CheckoutModel(
      checkoutUrl: map['checkout_url'] as String,
      orderReferenceId: map['order_reference_id'] as String,
      successUrl: map['success_url'] as String,
      cancelUrl: map['cancel_url'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'CheckoutModel(checkoutUrl: $checkoutUrl, orderReferenceId: $orderReferenceId, successUrl: $successUrl, cancelUrl: $cancelUrl, totalAmount: $totalAmount)';
  }
}
