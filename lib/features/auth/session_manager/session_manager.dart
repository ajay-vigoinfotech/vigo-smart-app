import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'username';
  static const String _tokenKey = 'token';
  static const String _accessToken = 'access_token';
  static const String _moduleCodesKey = 'module_codes';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessToken, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(_accessToken);
    return token;
  }

  Future<void> saveLoginInfo(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_usernameKey, username);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_tokenKey);
  }

  Future<void> saveModuleCodes(List<String> moduleCodes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_moduleCodesKey, moduleCodes);
  }

  Future<List<String>?> getModuleCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_moduleCodesKey);
  }
}
