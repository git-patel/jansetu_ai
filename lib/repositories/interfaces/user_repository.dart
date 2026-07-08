/// User Profile & Governance Repository Interface
/// Manages user metadata, jurisdictional polygons, language preferences, and role assignments.
abstract class UserRepository {
  Future<Map<String, dynamic>> getProfile(String userId);
  Future<void> updateProfile(String userId, Map<String, dynamic> updatedData);
  Future<Map<String, dynamic>> getJurisdictionArea(String areaCode);
  Future<List<String>> getPermissions(String userId);
  Future<void> setLanguage(String userId, String langCode);
  Future<void> updateRole(String userId, String newRole);
  Future<void> updateSettings(String userId, Map<String, dynamic> settings);
}
