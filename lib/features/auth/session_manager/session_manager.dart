import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'username';
  // final _tokenKey = 'token';
  //
  // Future<void> saveToken(token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_tokenKey, token);
  // }
  //
  // Future<String?> getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_tokenKey);
  // }

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
    //await prefs.remove(_tokenKey);
  }
}
