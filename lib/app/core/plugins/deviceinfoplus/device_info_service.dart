import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _plugin = DeviceInfoPlugin();
  static Map<String, dynamic>? _cachedDeviceInfo;

  
  static Future<void> init() async {
    _cachedDeviceInfo = await _getDeviceInfo();
  }

 
  static Map<String, dynamic>? get info => _cachedDeviceInfo;


  static Future<Map<String, dynamic>> refresh() async {
    _cachedDeviceInfo = await _getDeviceInfo();
    return _cachedDeviceInfo!;
  }

  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    final info = await _plugin.deviceInfo;

    if (info is AndroidDeviceInfo) {
      return {
        'platform': 'android',
        'device_id': info.id, // Android unique device ID
        'model': info.model,
        'brand': info.brand,
        'device': info.device,
        'sdk': info.version.sdkInt,
        'osVersion': info.version.release,
        'manufacturer': info.manufacturer,
        'isPhysicalDevice': info.isPhysicalDevice,
      };
    }

    if (info is IosDeviceInfo) {
      return {
        'platform': 'ios',
        'device_id': info.identifierForVendor, // iOS unique identifier
        'model': info.model,
        'systemName': info.systemName,
        'systemVersion': info.systemVersion,
        'identifier': info.identifierForVendor,
        'isPhysicalDevice': info.isPhysicalDevice,
      };
    }

    return {'platform': 'unknown'};
  }
}
