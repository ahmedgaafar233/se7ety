import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Onboarding
  static Future<void> setIsOnboarded(bool value) async {
    await _prefs.setBool('is_onboarded', value);
  }

  static bool getIsOnboarded() {
    return _prefs.getBool('is_onboarded') ?? false;
  }

  // User Caching
  static Future<void> saveUserData({
    required String uid,
    required String name,
    required String role,
  }) async {
    await _prefs.setString('uid', uid);
    await _prefs.setString('name', name);
    await _prefs.setString('role', role);
    await _prefs.setBool('is_logged_in', true);
  }

  static String? getUserId() => _prefs.getString('uid');
  static String? getUserName() => _prefs.getString('name');
  static String? getUserRole() => _prefs.getString('role');
  static bool getIsLoggedIn() => _prefs.getBool('is_logged_in') ?? false;

  static Future<void> logout() async {
    await _prefs.remove('uid');
    await _prefs.remove('name');
    await _prefs.remove('role');
    await _prefs.remove('is_profile_completed');
    await _prefs.setBool('is_logged_in', false);
  }

  static Future<void> setIsProfileCompleted(bool value) async {
    await _prefs.setBool('is_profile_completed', value);
  }

  static bool getIsProfileCompleted() {
    return _prefs.getBool('is_profile_completed') ?? false;
  }
}
