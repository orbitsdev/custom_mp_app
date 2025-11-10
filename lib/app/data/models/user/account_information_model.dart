import 'dart:convert';

/// Represents a user's additional profile details.
/// Matches Laravel's `AccountInformationResource` response.
class AccountInformationModel {
  final int? id;
  final String fullName;
  final String phoneNumber;
  final String gender;
  final Map<String, dynamic>? dateOfBirth;
  const AccountInformationModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    this.dateOfBirth,
  });

  /// Clone with new values
  AccountInformationModel copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    String? gender,
    Map<String, dynamic>? dateOfBirth,
  }) {
    return AccountInformationModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  /// Factory: Create from Map
  factory AccountInformationModel.fromMap(Map<String, dynamic> map) {
    final dob = map['date_of_birth'];
    return AccountInformationModel(
      id: map['id'],
      fullName: map['full_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: dob is Map<String, dynamic>
          ? Map<String, dynamic>.from(dob)
          : (dob != null ? {'formatted': dob, 'original': dob} : null),
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    };
  }

  /// JSON serialization helpers
  factory AccountInformationModel.fromJson(String source) =>
      AccountInformationModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  /// Helper getters for readability in UI
  String? get formattedDate =>
      dateOfBirth != null ? dateOfBirth!['formatted'] as String? : null;

  int? get age =>
      dateOfBirth != null ? dateOfBirth!['age'] as int? : null;

  String? get rawDate =>
      dateOfBirth != null ? dateOfBirth!['original'] as String? : null;

  @override
  String toString() {
    return 'AccountInformationModel(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, gender: $gender, dateOfBirth: $dateOfBirth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountInformationModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.dateOfBirth.toString() == dateOfBirth.toString();
  }

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      phoneNumber.hashCode ^
      gender.hashCode ^
      dateOfBirth.hashCode;
}
