import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../remote/dto/login_dto.dart';

/// Stores data locally on the device (survives app restarts). SharedPreferences
/// is like a simple key-value store (similar to Android's SharedPreferences).
class PreferencesManager {
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  SharedPreferences? _prefs;

  /// Lazy init: we only load SharedPreferences when first needed.
  /// ??= means "assign only if null" - avoids loading more than once.
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Saves user data and marks the user as logged in.
  /// toJson() converts the object to a map, jsonEncode turns it into a JSON string.
  Future<void> saveUserData(UserDataDto userData) async {
    final p = await prefs;
    final json = jsonEncode(userData.toJson());
    await p.setString(_keyUserData, json);
    await p.setBool(_keyIsLoggedIn, true);
  }

  /// Loads saved user data. Returns null if none saved or if JSON is invalid.
  /// jsonDecode parses the string back to a map; fromJson builds the object.
  Future<UserDataDto?> getUserData() async {
    final p = await prefs;
    final json = p.getString(_keyUserData);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return UserDataDto.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Checks whether the user is currently logged in (based on saved flag).
  Future<bool> isLoggedIn() async {
    final p = await prefs;
    return p.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Clears saved user data and logs the user out.
  Future<void> clearUserData() async {
    final p = await prefs;
    await p.remove(_keyUserData);
    await p.setBool(_keyIsLoggedIn, false);
  }
}
