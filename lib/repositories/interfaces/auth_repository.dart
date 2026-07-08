/// Authentication Repository Interface
/// Isulates identity provider logic (e.g. Parichay OTP, DigiLocker, Firebase Auth, Demo Sandbox).
abstract class AuthRepository {
  Future<void> login(String mobileOrId, String otp);
  Future<void> logout();
  Future<String?> refreshToken();
  Future<bool> verifyOtp(String mobile, String otp);
  Future<void> demoLogin(String role, Map<String, dynamic> profile);
  Future<Map<String, dynamic>?> getCurrentUser();
  Future<bool> restoreSession();
  Future<String?> detectRole();
  String? get activeRole;
  Map<String, dynamic>? get userProfile;
  bool get hasCompletedOnboarding;
  String get selectedLanguage;
  Future<void> setLanguage(String lang);
  Future<void> completeOnboarding(String lang);
}
