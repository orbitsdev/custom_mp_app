import 'package:intl/intl.dart';

final NumberFormat money = NumberFormat("#,##0.##", "en_US");

String formatMoney(num amount) {
  // Convert to double safely
  double value = amount.toDouble();


  return money.format(value);
}

String formatNumber(num value) {
  final hasDecimal = (value % 1) != 0;
  final s = value.toStringAsFixed(hasDecimal ? 2 : 0);

  return s.replaceAllMapped(
    RegExp(r"(\d)(?=(\d{3})+(?!\d))"),
    (m) => "${m[1]},",
  );
}

/// Price formatter with peso sign.
/// 1000     → "₱1,000"
/// 98.75    → "₱98.75"
String formatPrice(num value) {
  return formatNumber(value);
}

/// Short number (Optional).
/// 1000 → "1K"
/// 12000 → "12K"
/// 1,200,000 → "1.2M"
String formatShort(num value) {
  if (value >= 1000000) {
    return "${(value / 1000000).toStringAsFixed(1)}M";
  } else if (value >= 1000) {
    return "${(value / 1000).toStringAsFixed(1)}K";
  }
  return value.toString();
}

/// Locale-aware formatter (optional)
final NumberFormat moneyIntl = NumberFormat("#,##0.##", "en_US");

String formatMoneyIntl(num value) {
  return moneyIntl.format(value.toDouble());
}