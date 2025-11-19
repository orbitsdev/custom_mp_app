// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'cart_variant_model.dart';

class CartItemModel {
  final int? id;
  final int? quantity;
  final bool? isSelected;
  final double? unitPrice;
  final double? adjustmentAmount;
  final List<dynamic>? adjustmentDetails;

  final double? finalPrice;
  final double? subtotal;

  final CartVariantModel? variant;
  CartItemModel({
    this.id,
    this.quantity,
    this.isSelected,
    this.unitPrice,
    this.adjustmentAmount,
    this.adjustmentDetails,
    this.finalPrice,
    this.subtotal,
    this.variant,
  });
 
 

  // ---------- FACTORY ----------

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      quantity: map['quantity'],
      isSelected: map['is_selected'] ?? false,
      unitPrice: (map['unit_price'] ?? 0).toDouble(),
      adjustmentAmount: (map['adjustment_amount'] ?? 0).toDouble(),
      adjustmentDetails: map['adjustment_details'] ?? [],
      finalPrice: (map['final_price'] ?? 0).toDouble(),
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      variant: CartVariantModel.fromMap(map['variant']),
    );
  }

  // ---------- MAP CONVERSION ----------

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'is_selected': isSelected,
      'unit_price': unitPrice,
      'adjustment_amount': adjustmentAmount,
      'adjustment_details': adjustmentDetails,
      'final_price': finalPrice,
      'subtotal': subtotal,
      'variant': variant?.toMap() ,
    };
  }

  // ---------- JSON HELPERS ----------

  String toJson() => json.encode(toMap());
  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));

  // ---------- COPY WITH ----------

  CartItemModel copyWith({
    int? id,
    int? quantity,
    bool? isSelected,
    double? unitPrice,
    double? adjustmentAmount,
    List<dynamic>? adjustmentDetails,
    double? finalPrice,
    double? subtotal,
    CartVariantModel? variant,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      unitPrice: unitPrice ?? this.unitPrice,
      adjustmentAmount: adjustmentAmount ?? this.adjustmentAmount,
      adjustmentDetails: adjustmentDetails ?? this.adjustmentDetails,
      finalPrice: finalPrice ?? this.finalPrice,
      subtotal: subtotal ?? this.subtotal,
      variant: variant ?? this.variant,
    );
  }

  // ---------- DEBUG ----------

  @override
  String toString() {
    return 'CartItemModel(id: $id, qty: $quantity, selected: $isSelected, '
        'unitPrice: $unitPrice, adj: $adjustmentAmount, subtotal: $subtotal, variant: $variant)';
  }

  // ---------- EQUALITY ----------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
