// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  final String regionCode;
  final String provinceCode;
  final String municipalityCode;
  final String barangayCode;

  final String street;
  final String? landmark;
  final String postalCode;

  /// 👇 ADD THIS
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
    required this.regionCode,
    required this.provinceCode,
    required this.municipalityCode,
    required this.barangayCode,
    required this.street,
    this.landmark,
    required this.postalCode,

    /// 👇 REQUIRED
    required this.fullAddress,
  });

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

      regionCode: map['region']['code'] ?? '',
      provinceCode: map['province']['code'] ?? '',
      municipalityCode: map['municipality']['code'] ?? '',
      barangayCode: map['barangay']['code'] ?? '',

      street: map['street'] ?? '',
      landmark: map['landmark'],
      postalCode: map['postal_code'] ?? '',

      /// 👇 ADD THIS
      fullAddress: map['full_address'] ?? '',
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'type': type,

      'region': region.toMap(),
      'province': province.toMap(),
      'municipality': municipality.toMap(),
      'barangay': barangay.toMap(),

      'region_code': regionCode,
      'province_code': provinceCode,
      'municipality_code': municipalityCode,
      'barangay_code': barangayCode,

      'street': street,
      'landmark': landmark,
      'postal_code': postalCode,
    };
  }

  ShippingAddressModel copyWith({
    int? id,
    bool? isDefault,
    String? fullName,
    String? phoneNumber,
    String? type,
    RegionModel? region,
    RegionModel? province,
    RegionModel? municipality,
    RegionModel? barangay,
    String? regionCode,
    String? provinceCode,
    String? municipalityCode,
    String? barangayCode,
    String? street,
    String? landmark,
    String? postalCode,
    String? fullAddress,
  }) {
    return ShippingAddressModel(
      id: id ?? this.id,
      isDefault: isDefault ?? this.isDefault,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      region: region ?? this.region,
      province: province ?? this.province,
      municipality: municipality ?? this.municipality,
      barangay: barangay ?? this.barangay,
      regionCode: regionCode ?? this.regionCode,
      provinceCode: provinceCode ?? this.provinceCode,
      municipalityCode: municipalityCode ?? this.municipalityCode,
      barangayCode: barangayCode ?? this.barangayCode,
      street: street ?? this.street,
      landmark: landmark ?? this.landmark,
      postalCode: postalCode ?? this.postalCode,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }
}
