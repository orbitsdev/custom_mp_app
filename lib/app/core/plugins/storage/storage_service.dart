import 'package:get_storage/get_storage.dart';

/// Service for managing non-sensitive app data using GetStorage
/// For sensitive data (tokens, user info), use SecureStorageService instead
class StorageService {
  static final _box = GetStorage();

  // Onboarding
  static const String _onboardingKey = 'has_seen_onboarding';

  static bool hasSeenOnboarding() {
    return _box.read(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    await _box.write(_onboardingKey, true);
  }

  // Add other non-sensitive storage keys here as needed
  // Example: theme preferences, language settings, etc.
}
