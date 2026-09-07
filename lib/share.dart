import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Keys
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';
  static const String _keyConfirmPassword = 'confirmPassword';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyBmiHistory = 'bmi_history';

  // ============================================================
  // USER NAME
  // ============================================================
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  // ============================================================
  // EMAIL
  // ============================================================
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // ============================================================
  // PASSWORD
  // ============================================================
  static Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, password);
    await prefs.setString(_keyConfirmPassword, password);
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword) ?? prefs.getString(_keyConfirmPassword);
  }

  static Future<void> saveConfirmPassword(String password) async {
    await savePassword(password);
  }

  static Future<String?> getConfirmPassword() async {
    return getPassword();
  }

  // ============================================================
  // LOGIN STATUS
  // ============================================================
  static Future<void> saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, status);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ============================================================
  // BMI HISTORY
  // ============================================================
  static Future<void> saveHistory({
    required String date,
    required double weight,
    required double height,
    required double bmi,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_keyBmiHistory) ?? [];

    Map<String, dynamic> record = {
      'date': date,
      'weight': weight,
      'height': height,
      'bmi': bmi,
    };

    history.add(jsonEncode(record));
    await prefs.setStringList(_keyBmiHistory, history);
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_keyBmiHistory) ?? [];

    return history.map((item) {
      return jsonDecode(item) as Map<String, dynamic>;
    }).toList().reversed.toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBmiHistory);
  }

  // ============================================================
  // LOGOUT & CLEAR
  // ============================================================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}