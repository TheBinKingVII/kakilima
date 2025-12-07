import 'package:shared_preferences/shared_preferences.dart';

class LocationSharingStorage {
  static const String _key = 'location_sharing_active';

  /// Get the stored location sharing status
  static Future<bool> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// Save the location sharing status
  static Future<void> setStatus(bool isActive) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isActive);
  }

  /// Clear the stored location sharing status
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

