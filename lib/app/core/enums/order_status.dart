enum OrderStatus {
  pending('pending'),
  placed('placed'),
  canceled('canceled'), // American spelling to match backend API
  processing('processing'),
  paid('paid'),
  preparing('preparing'),
  outForDelivery('out_for_delivery'),
  delivered('delivered'),
  returned('returned'),
  readyForPickup('ready_for_pickup'),
  completed('completed');

  final String value;
  const OrderStatus(this.value);

  /// Convert from string to enum
  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }

  /// Convert enum to string
  @override
  String toString() => value;
}
