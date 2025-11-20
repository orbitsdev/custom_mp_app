// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_mp_app/app/data/models/shippingaddress/region_model.dart';

class ShippingAddressModel {
  final int? id;
  final bool? isDefault;
  final String? fullName;
  final String? phoneNumber;
  final String? type;

  final RegionModel region;
  final RegionModel province;
  final RegionModel municipality;
  final RegionModel barangay;

  final String? street;
  final String? landmark;
  final String? postalCode;
  final String? fullAddress;

 ShippingAddressModel({
    this.id,
    this.isDefault,
    this.fullName,
    this.phoneNumber,
    this.type,
    required this.region,
    required this.province,
    required this.municipality,
    required this.barangay,
    this.street,
    this.landmark,
    this.postalCode,
    this.fullAddress,
  });

  //from map with defualt value 
  factory ShippingAddressModel.fromMap(Map<String, dynamic> map) {
    return ShippingAddressModel(
      id: map['id'] ?? 0,
      isDefault: map['is_default'] ?? false,
      fullName: map['full_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      type: map['type'] ?? '',
      region: RegionModel.fromMap(map['region'] ?? {}),
      province: RegionModel.fromMap(map['province'] ?? {}),
      municipality: RegionModel.fromMap(map['municipality'] ?? {}),
      barangay: RegionModel.fromMap(map['barangay'] ?? {}),
      street: map['street'] ?? '',
      landmark: map['landmark'] ?? '',
      postalCode: map['postal_code'] ?? '',
      fullAddress: map['full_address'] ?? '',
    );
  }

  


  @override
  String toString() {
    return 'ShippingAddressModel(id: $id, isDefault: $isDefault, fullName: $fullName, phoneNumber: $phoneNumber, type: $type, region: $region, province: $province, municipality: $municipality, barangay: $barangay, street: $street, landmark: $landmark, postalCode: $postalCode, fullAddress: $fullAddress)';
  }
}
