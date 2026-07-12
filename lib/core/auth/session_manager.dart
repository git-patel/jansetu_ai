import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _sessionTokenKey = 'jansetu_session_token';
  static const String _userUidKey = 'jansetu_user_uid';

  Future<void> saveSession(String uid, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionTokenKey, token);
    await prefs.setString(_userUidKey, uid);
  }

  Future<String?> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionTokenKey);
  }

  Future<String?> getUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userUidKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionTokenKey);
    await prefs.remove(_userUidKey);
  }

  Future<bool> hasActiveSession() async {
    final token = await getSessionToken();
    return token != null && token.isNotEmpty;
  }
}
