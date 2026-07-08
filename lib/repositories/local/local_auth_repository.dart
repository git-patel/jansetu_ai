import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/secure_storage.dart';
import '../interfaces/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  static const String _roleKey = 'jansetu_active_role_v1';
  static const String _profileKey = 'jansetu_user_profile_v1';
  static const String _onboardingKey = 'jansetu_onboarding_completed_v1';
  static const String _langKey = 'jansetu_language_pref_v1';

  String? _activeRole;
  Map<String, dynamic>? _userProfile;
  bool _onboardingCompleted = false;
  String _selectedLanguage = 'English';

  @override
  String? get activeRole => _activeRole;

  @override
  Map<String, dynamic>? get userProfile => _userProfile;

  @override
  bool get hasCompletedOnboarding => _onboardingCompleted;

  @override
  String get selectedLanguage => _selectedLanguage;

  @override
  Future<void> login(String mobileOrId, String otp) async {
    JanSetuLogger.info('Logging in with mobile: $mobileOrId', 'LocalAuth');
    await demoLogin('CITIZEN', {
      'name': 'Rajesh Bhai Patel (Verified Citizen)',
      'id': 'CIT-SRT-8841',
      'role': 'CITIZEN',
      'jurisdiction': 'WRD-GUJ-SRT-0014',
      'wardName': 'Adajan Ward 14',
      'city': 'Surat',
      'mobile': mobileOrId,
    });
  }

  @override
  Future<void> demoLogin(String role, Map<String, dynamic> profile) async {
    _activeRole = role;
    _userProfile = profile;
    SecureStorageService.generateSessionToken(profile['id']?.toString() ?? 'DEMO', role);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
    await prefs.setString(_profileKey, json.encode(profile));
    JanSetuLogger.success('Demo login successful as $role', 'LocalAuth');
  }

  @override
  Future<void> logout() async {
    _activeRole = null;
    _userProfile = null;
    SecureStorageService.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
    await prefs.remove(_profileKey);
    JanSetuLogger.warning('Logged out of session', 'LocalAuth');
  }

  @override
  Future<String?> refreshToken() async {
    return SecureStorageService.activeToken;
  }

  @override
  Future<bool> verifyOtp(String mobile, String otp) async {
    return otp == '999999' || otp.length == 6;
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return _userProfile;
  }

  @override
  Future<bool> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingCompleted = prefs.getBool(_onboardingKey) ?? false;
    _selectedLanguage = prefs.getString(_langKey) ?? 'English';

    if (prefs.containsKey(_roleKey)) {
      _activeRole = prefs.getString(_roleKey);
    }
    if (prefs.containsKey(_profileKey)) {
      try {
        final cached = prefs.getString(_profileKey);
        if (cached != null) {
          _userProfile = json.decode(cached) as Map<String, dynamic>;
        }
      } catch (e) {
        JanSetuLogger.error('Failed to restore user profile', e, null, 'LocalAuth');
      }
    }
    return _activeRole != null;
  }

  @override
  Future<String?> detectRole() async {
    return activeRole;
  }

  @override
  Future<void> setLanguage(String lang) async {
    _selectedLanguage = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, lang);
    JanSetuLogger.info('Language set to $lang', 'LocalAuth');
  }

  @override
  Future<void> completeOnboarding(String lang) async {
    _onboardingCompleted = true;
    _selectedLanguage = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    await prefs.setString(_langKey, lang);
    JanSetuLogger.success('Onboarding completed in $lang', 'LocalAuth');
  }
}
