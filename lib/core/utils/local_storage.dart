import 'package:hive_flutter/hive_flutter.dart';


class LocalStorage {
  static const String _userBox = 'user_box';
  static const String _settingsBox = 'settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Open boxes
    await Hive.openBox(_userBox);
    await Hive.openBox(_settingsBox);
  }

  static Box get userBox => Hive.box(_userBox);
  static Box get settingsBox => Hive.box(_settingsBox);

  // Save auth token
  static Future<void> saveToken(String token) async {
    await userBox.put('token', token);
  }

  // Get auth token
  static String? getToken() {
    return userBox.get('token');
  }

  // Clear all data
  static Future<void> clearAll() async {
    await userBox.clear();
    await settingsBox.clear();
  }
}
