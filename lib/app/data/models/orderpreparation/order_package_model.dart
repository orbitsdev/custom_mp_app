// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  factory OrderPackageModel.fromMap(Map<String, dynamic> map) {
    return OrderPackageModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      availableStock: map['available_stock'] ?? 0,
      minWeightKg: (map['min_weight_kg'] as num).toDouble(),
      maxWeightKg: (map['max_weight_kg'] as num).toDouble(),
      isAvailableForCheckout: map['is_available_for_checkout'] ?? false,
      thumbnail: map['thumbnail'] ?? '',
    );
  }

  // 
  // factory OrderPackageModel.fromMap(Map<String, dynamic> map) {
  //   return OrderPackageModel(
  //     id: map['id'] ?? 0,
  //     name: map['name'] ?? '',
  //     price: map['price'] ?? 0,
  //     availableStock: map['available_stock'] ?? 0,
  //     minWeightKg:  map['min_weight_kg'] as double,
  //     maxWeightKg: map['max_weight_kg'] as double,
  //     isAvailableForCheckout: map['is_available_for_checkout'] ?? false,
  //     thumbnail: map['thumbnail'] ?? '',
  //   );
    
  // }

  @override
  String toString() {
    return 'OrderPackageModel(id: $id, name: $name, price: $price, availableStock: $availableStock, minWeightKg: $minWeightKg, maxWeightKg: $maxWeightKg, isAvailableForCheckout: $isAvailableForCheckout, thumbnail: $thumbnail)';
  }
}
