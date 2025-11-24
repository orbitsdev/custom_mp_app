class OrderDateModel {
  final String formatted;
  final String human;
  final int timestamp;

  OrderDateModel({
    required this.formatted,
    required this.human,
    required this.timestamp,
  });

  factory OrderDateModel.fromMap(Map<String, dynamic> map) {
    return OrderDateModel(
      formatted: map['formatted'] ?? '',
      human: map['human'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'formatted': formatted,
      'human': human,
      'timestamp': timestamp,
    };
  }
}
