import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String keyToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOfflinePasscode = 'offline_passcode';

  static Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyThemeMode, mode);
  }

  static Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyThemeMode);
  }

  static Future<void> saveOfflinePasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyOfflinePasscode, passcode);
  }

  static Future<String?> getOfflinePasscode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyOfflinePasscode);
  }

  static Future<void> clearOfflinePasscode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyOfflinePasscode);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyRefreshToken, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRefreshToken);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    await prefs.remove(keyRefreshToken);
  }

  static Future<void> saveCache(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
