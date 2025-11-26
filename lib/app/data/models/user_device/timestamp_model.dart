class TimestampModel {
  final String formatted;
  final String human;
  final int timestamp;

  TimestampModel({
    required this.formatted,
    required this.human,
    required this.timestamp,
  });

  factory TimestampModel.fromMap(Map<String, dynamic> map) {
    return TimestampModel(
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
