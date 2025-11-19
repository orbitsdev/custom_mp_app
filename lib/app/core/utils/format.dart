import 'package:intl/intl.dart';

final NumberFormat money = NumberFormat("#,##0.##", "en_US");

String formatMoney(num amount) {
  // Convert to double safely
  double value = amount.toDouble();


  return money.format(value);
}
