class UserDeviceModel {
  final int id;
  final int userId;
  final String deviceId;
  final String fcmToken;
  final String platform;
  final String? deviceModel;
  final String? appVersion;
  final bool isActive;
  final String? lastUsedAt;
  final String createdAt;
  final String updatedAt;

  UserDeviceModel({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.fcmToken,
    required this.platform,
    this.deviceModel,
    this.appVersion,
    required this.isActive,
    this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDeviceModel.fromMap(Map<String, dynamic> map) {
    return UserDeviceModel(
      id: map['id'] ?? 0,
      userId: map['user_id'] ?? 0,
      deviceId: map['device_id'] ?? '',
      fcmToken: map['fcm_token'] ?? '',
      platform: map['platform'] ?? '',
      deviceModel: map['device_model'],
      appVersion: map['app_version'],
      isActive: map['is_active'] ?? false,
      lastUsedAt: map['last_used_at'],
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'fcm_token': fcmToken,
      'platform': platform,
      'device_model': deviceModel,
      'app_version': appVersion,
      'is_active': isActive,
      'last_used_at': lastUsedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
