import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const String _loginStatusKey = 'login_status';
  static const String _cookieKey = 'cookies';
  static const String _employeeIdKey = 'employee_id';
  static const String _userDetails = "user_details";
  static const String _isEmployee = "is_employee";
  static const String _tokenKey = "auth_token";
  static final AuthStorageService _instance = AuthStorageService._internal();
  late final SharedPreferences _prefs;

  factory AuthStorageService() {
    return _instance;
  }

  AuthStorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveLoginStatus(bool value) async {
    await _prefs.setBool(_loginStatusKey, value);
  }

  Future<bool> getLoginStatus() async {
    return _prefs.getBool(_loginStatusKey) ?? false;
  }

  Future<void> saveCookie(String value) async {
    await _prefs.setString(_cookieKey, value);
  }

  Future<String?> getCookie() async {
    return _prefs.getString(_cookieKey);
  }

  Future<void> saveEmployeeId(String value) async {
    await _prefs.setString(_employeeIdKey, value);
  }

  Future<String> getEmployeeId() async {
    return _prefs.getString(_employeeIdKey) ?? '';
  }

  Future<void> saveUserDetail(Map<String, dynamic> myProfileResponse) async {
    try {
      await _prefs.setString(_userDetails, jsonEncode(myProfileResponse));
    } catch (e) {
      print("Error saving user details: $e");
    }
  }

  Future<Map<String, dynamic>?> getUserDetail() async {
    String? value = _prefs.getString(_userDetails);
    if (value != null) {
      return jsonDecode(value);
    }
    return null;
  }

  Future<void> saveIsEmployee(bool value) async {
    log("value: $value");
    await _prefs.setBool(_isEmployee, value);
  }

  bool getIsEmployee() {
    return _prefs.getBool(_isEmployee) ?? false;
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_loginStatusKey);
    await _prefs.remove(_cookieKey);
    await _prefs.remove(_employeeIdKey);
    await _prefs.remove(_userDetails);
    await _prefs.remove(_isEmployee);
    await _prefs.remove(_tokenKey);
  }
}
