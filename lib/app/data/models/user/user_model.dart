import 'dart:convert';

import 'package:custom_mp_app/app/data/models/user/account_information_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String profilePhotoUrl;
  final AccountInformationModel? accountInformation;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.profilePhotoUrl,
    this.accountInformation,
  });

  // ✅ Create a copy with updated fields
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? createdAt,
    String? profilePhotoUrl,
    AccountInformationModel? accountInformation,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      accountInformation: accountInformation ?? this.accountInformation,
    );
  }

  // ✅ Convert from raw Map (from API)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['created_at'] ?? '',
      profilePhotoUrl: map['profile_photo_url'] ?? '',
      accountInformation: map['account_information'] != null
          ? AccountInformationModel.fromMap(map['account_information'])
          : null,
    );
  }

  // ✅ Convert to Map (for local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt,
      'profile_photo_url': profilePhotoUrl,
      'account_information': accountInformation?.toMap(),
    };
  }

  // ✅ fromJson (string → object)
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  // ✅ toJson (object → string)
  String toJson() => json.encode(toMap());

  // ✅ String representation (for debugging)
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, createdAt: $createdAt, profilePhotoUrl: $profilePhotoUrl, accountInformation: $accountInformation)';
  }

  // ✅ Equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.createdAt == createdAt &&
        other.profilePhotoUrl == profilePhotoUrl &&
        other.accountInformation == accountInformation;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        createdAt.hashCode ^
        profilePhotoUrl.hashCode ^
        accountInformation.hashCode;
  }
}

