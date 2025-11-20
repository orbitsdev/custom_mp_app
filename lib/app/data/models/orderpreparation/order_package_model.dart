class OrderPackageModel {
  final int id;
  final String name;
  final int price;
  final int availableStock;
  final double minWeightKg;
  final double maxWeightKg;
  final bool isAvailableForCheckout;
  final String thumbnail;

  OrderPackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.availableStock,
    required this.minWeightKg,
    required this.maxWeightKg,
    required this.isAvailableForCheckout,
    required this.thumbnail,
  });

  factory OrderPackageModel.fromJson(Map<String, dynamic> json) {
    return OrderPackageModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      availableStock: json['available_stock'],
      minWeightKg: (json['min_weight_kg'] as num).toDouble(),
      maxWeightKg: (json['max_weight_kg'] as num).toDouble(),
      isAvailableForCheckout: json['is_available_for_checkout'],
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}
