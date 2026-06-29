import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class SharedPrefs {
  static const String _keyToken = 'auth_token';
  static const String _keyLanguage = 'language_code';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserMobile = 'user_mobile';
  static const String _keyIsLogin = 'is_login';
  static const String _keyIsGuest = 'is_guest';
  static const String _keyUserData = 'user_data';

  // Token Management
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  /// Backwards-compatible alias used in some places of the codebase.
  /// Previously the project referenced `clearToken()`. Keep this to avoid
  /// having to update many call sites—delegates to [removeToken].
  static Future<void> clearToken() async {
    await removeToken();
  }

  // Language Management
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  // Login Status Management
  static Future<void> setLoginStatus(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, isLogin);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }

  // Guest mode management
  static Future<void> setGuestStatus(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGuest, isGuest);
  }

  static Future<bool> getGuestStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsGuest) ?? false;
  }

  // Save complete user data
  /// Save the entire [UserModel] as a single JSON entry.
  /// This is the preferred API — other getters will read from this stored
  /// user JSON when available.
  static Future<void> saveUserModel(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
  }

  /// Read whole `UserModel` from preferences, or null if not present.
  static Future<UserModel?> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUserData);
    if (raw == null) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  // Clear all data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Logout - clear auth data but keep language preference
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString(_keyLanguage);
    await prefs.clear();
    if (language != null) {
      await prefs.setString(_keyLanguage, language);
    }
  }
}


