import 'package:custom_mp_app/app/data/models/shippingaddress/region_model.dart';

class ShippingAddressModel {
  final int id;
  final bool isDefault;
  final String fullName;
  final String phoneNumber;
  final String type;

  final RegionModel region;
  final RegionModel province;
  final RegionModel municipality;
  final RegionModel barangay;

  final String street;
  final String landmark;
  final String postalCode;
  final String fullAddress;

  ShippingAddressModel({
    required this.id,
    required this.isDefault,
    required this.fullName,
    required this.phoneNumber,
    required this.type,
    required this.region,
    required this.province,
    required this.municipality,
    required this.barangay,
    required this.street,
    required this.landmark,
    required this.postalCode,
    required this.fullAddress,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: json['id'],
      isDefault: json['is_default'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      type: json['type'],

      region: RegionModel.fromJson(json['region']),
      province: RegionModel.fromJson(json['province']),
      municipality: RegionModel.fromJson(json['municipality']),
      barangay: RegionModel.fromJson(json['barangay']),

      street: json['street'],
      landmark: json['landmark'] ?? '',
      postalCode: json['postal_code'],
      fullAddress: json['full_address'],
    );
  }
}
