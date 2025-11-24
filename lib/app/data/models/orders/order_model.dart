import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/data/models/orders/order_date_model.dart';

class OrderModel {
  final int id;
  final String orderReferenceId;
  final OrderStatus orderStatus;
  final String paymentType;
  final String? paymentMethodUsed;
  final String deliveryType;
  final String? paidAt; // nullable - null means unpaid, non-null means paid
  final bool isActive;
  final num totalPrice;
  final num totalItemPrice;
  final num shippingFee;
  final OrderDateModel? orderedAt;
  final OrderDateModel createdAt;
  final OrderDateModel updatedAt;
  final Map<String, dynamic>? shippingAddressSnapshot;
  final List<Map<String, dynamic>> cartItemsSnapshot;
  final Map<String, dynamic>? packageSnapshot;

  OrderModel({
    required this.id,
    required this.orderReferenceId,
    required this.orderStatus,
    required this.paymentType,
    this.paymentMethodUsed,
    required this.deliveryType,
    this.paidAt,
    required this.isActive,
    required this.totalPrice,
    required this.totalItemPrice,
    required this.shippingFee,
    this.orderedAt,
    required this.createdAt,
    required this.updatedAt,
    this.shippingAddressSnapshot,
    required this.cartItemsSnapshot,
    this.packageSnapshot,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    try {
      return OrderModel(
        id: map['id'] ?? 0,
        orderReferenceId: map['order_reference_id'] ?? '',
        orderStatus: OrderStatus.fromString(map['order_status'] ?? 'pending'),
        paymentType: map['payment_type'] ?? '',
        paymentMethodUsed: map['payment_method_used'],
        deliveryType: map['delivery_type'] ?? '',
        paidAt: map['paid_at'],
        isActive: map['is_active'] ?? true,
        totalPrice: _parseNumeric(map['total_price']),
        totalItemPrice: _parseNumeric(map['total_item_price']),
        shippingFee: _parseNumeric(map['shipping_fee']),
        orderedAt: map['ordered_at'] != null
            ? OrderDateModel.fromMap(map['ordered_at'])
            : null,
        createdAt: OrderDateModel.fromMap(map['created_at'] ?? {}),
        updatedAt: OrderDateModel.fromMap(map['updated_at'] ?? {}),
        shippingAddressSnapshot: map['shipping_address_snapshot'],
        cartItemsSnapshot: map['cart_items_snapshot'] != null
            ? List<Map<String, dynamic>>.from(map['cart_items_snapshot'])
            : [],
        packageSnapshot: map['package_snapshot'],
      );
    } catch (e, stackTrace) {
      print('❌ [OrderModel] Error parsing order:');
      print('Map data: $map');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Helper method to safely parse numeric values from various types
  static num _parseNumeric(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_reference_id': orderReferenceId,
      'order_status': orderStatus.value,
      'payment_type': paymentType,
      'payment_method_used': paymentMethodUsed,
      'delivery_type': deliveryType,
      'paid_at': paidAt,
      'is_active': isActive,
      'total_price': totalPrice,
      'total_item_price': totalItemPrice,
      'shipping_fee': shippingFee,
      'ordered_at': orderedAt?.toMap(),
      'created_at': createdAt.toMap(),
      'updated_at': updatedAt.toMap(),
      'shipping_address_snapshot': shippingAddressSnapshot,
      'cart_items_snapshot': cartItemsSnapshot,
      'package_snapshot': packageSnapshot,
    };
  }

  // Getters
  bool get isPaid => paidAt != null;

  int get itemCount => cartItemsSnapshot.length;

  String get deliveryAddress {
    if (shippingAddressSnapshot == null) return 'Pickup';
    return shippingAddressSnapshot!['address'] ?? 'N/A';
  }
}
