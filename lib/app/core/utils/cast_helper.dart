int _asInt(dynamic v) {
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

double _asDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

String _asString(dynamic v) {
  if (v == null) return "";
  return v.toString();
}

bool _asBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is String) return v.toLowerCase() == "true";
  if (v is num) return v == 1;
  return false;
}

List<T> _asList<T>(dynamic v, T Function(dynamic) builder) {
  if (v is List) {
    return v.map((e) => builder(e)).toList();
  }
  return [];
}
