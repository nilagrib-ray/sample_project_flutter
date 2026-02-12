import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../remote/dto/login_dto.dart';

/// Equivalent of the Android PreferencesManager.
/// Uses SharedPreferences for local data persistence.
class PreferencesManager {
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveUserData(UserDataDto userData) async {
    final p = await prefs;
    final json = jsonEncode(userData.toJson());
    await p.setString(_keyUserData, json);
    await p.setBool(_keyIsLoggedIn, true);
  }

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

  Future<bool> isLoggedIn() async {
    final p = await prefs;
    return p.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> clearUserData() async {
    final p = await prefs;
    await p.remove(_keyUserData);
    await p.setBool(_keyIsLoggedIn, false);
  }
}
