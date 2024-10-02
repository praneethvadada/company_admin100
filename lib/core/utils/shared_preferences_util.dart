import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    print('Token saved in shared preferences: $token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print('Retrieved token from shared preferences: $token');
    return token;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Clear the token during logout
    print('Token cleared from shared preferences');
  }
}
