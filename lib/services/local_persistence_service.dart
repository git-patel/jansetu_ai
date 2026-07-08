import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/service_locator.dart';
import '../core/utils/cache_manager.dart';
import '../core/utils/logger.dart';

/// Local Client Persistence Service (LocalPersistenceService)
/// Refactored per Prompt 14 as an architectural Facade that strictly delegates
/// all storage interactions to interface-driven Repositories via ServiceLocator.
/// Ensures zero UI modifications or test regressions while achieving Clean Architecture compliance.
class LocalPersistenceService {
  static const String _onboardingKey = 'jansetu_onboarding_completed_v1';
  static const String _langKey = 'jansetu_language_pref_v1';

  /// Initialize storage and load cached datasets via ServiceLocator repositories
  static Future<void> init() async {
    JanSetuLogger.info('Initializing LocalPersistenceService facade...', 'LocalPersistenceService');
    await ServiceLocator.instance.init(type: DataSourceType.local);
  }

  // --- Static Getters Delegating to Repositories ---

  static List<dynamic> get needs => ServiceLocator.instance.needRepository.getNeeds();
  static set needs(List<dynamic> value) {}

  static List<dynamic> get projects => ServiceLocator.instance.projectRepository.getProjects();
  static set projects(List<dynamic> value) {}

  static List<Map<String, dynamic>> get ledgerProjects => ServiceLocator.instance.projectRepository.getLedgerProjects();
  static set ledgerProjects(List<Map<String, dynamic>> value) {}

  static double get mpladsFundBalanceINR => ServiceLocator.instance.projectRepository.getMpladsFundBalanceINR();
  static set mpladsFundBalanceINR(double value) {}

  static String? get activeRole => ServiceLocator.instance.authRepository.activeRole;
  static set activeRole(String? value) {}

  static Map<String, dynamic>? get userProfile => ServiceLocator.instance.authRepository.userProfile;
  static set userProfile(Map<String, dynamic>? value) {}

  static bool get hasCompletedOnboarding => ServiceLocator.instance.authRepository.hasCompletedOnboarding;
  static set hasCompletedOnboarding(bool value) {}

  static String get selectedLanguage => ServiceLocator.instance.authRepository.selectedLanguage;
  static set selectedLanguage(String value) {}

  // --- Static Delegation Methods ---

  /// Login as a specific role and save profile
  static Future<void> loginAsRole(String role, Map<String, dynamic> profile) async {
    await ServiceLocator.instance.authRepository.demoLogin(role, profile);
  }

  /// Logout and clear active role session
  static Future<void> logout() async {
    await ServiceLocator.instance.authRepository.logout();
  }

  /// Mark onboarding as completed and store language preference
  static Future<void> completeOnboarding(String lang) async {
    await ServiceLocator.instance.authRepository.completeOnboarding(lang);
  }

  /// Update language preference
  static Future<void> setLanguage(String lang) async {
    await ServiceLocator.instance.authRepository.setLanguage(lang);
  }

  /// Save a newly submitted citizen grievance
  static Future<void> saveNeed(Map<String, dynamic> newNeed) async {
    await ServiceLocator.instance.needRepository.create(newNeed);
  }

  /// Upvote an existing grievance
  static Future<void> upvoteNeed(int index) async {
    if (index >= 0 && index < needs.length) {
      final need = Map<String, dynamic>.from(needs[index] as Map);
      need['upvoteCount'] = ((need['upvoteCount'] as num?)?.toInt() ?? 0) + 1;
      await ServiceLocator.instance.needRepository.update(index, need);
    }
  }

  /// Toggle support for a grievance (Prompt 08 rule: 1 support per citizen, pressing again removes support)
  /// Returns true if supported, false if support removed.
  static Future<bool> toggleSupportNeed(int index, String userId) async {
    return await ServiceLocator.instance.needRepository.toggleSupport(index, userId);
  }

  /// Check if user supports a given need index
  static bool isNeedSupported(int index, String userId) {
    return ServiceLocator.instance.needRepository.isSupportedByUser(index, userId);
  }

  /// Add a comment to a need
  static Future<void> addCommentToNeed(int index, Map<String, dynamic> comment) async {
    await ServiceLocator.instance.needRepository.addComment(index, comment);
  }

  /// Update/delete/like comment on a need
  static Future<void> updateCommentOnNeed(int needIndex, int commentIndex, Map<String, dynamic>? updatedComment) async {
    await ServiceLocator.instance.needRepository.updateComment(needIndex, commentIndex, updatedComment);
  }

  /// Save a newly sanctioned MPLADS capital project and deduct fund allocation
  static Future<void> saveSanction(Map<String, dynamic> newProject, double amountINR) async {
    await ServiceLocator.instance.projectRepository.saveSanction(newProject, amountINR);
  }

  /// Update an existing project (e.g. for escrow tranche releases or audits)
  static Future<void> updateProject(int index, Map<String, dynamic> updatedProject) async {
    await ServiceLocator.instance.projectRepository.updateProject(index, updatedProject);
  }

  /// Update an escrow audit ledger project
  static Future<void> updateLedgerProject(int index, Map<String, dynamic> updatedProject) async {
    await ServiceLocator.instance.projectRepository.updateLedgerProject(index, updatedProject);
  }

  /// Reset all storage caches to initial synthetic defaults (Demo Reset)
  static Future<void> resetToDefaults() async {
    final wasOnboarded = hasCompletedOnboarding;
    final lang = selectedLanguage;
    await CacheManager.clearAll();
    final prefs = await SharedPreferences.getInstance();
    if (wasOnboarded) {
      await prefs.setBool(_onboardingKey, true);
      await prefs.setString(_langKey, lang);
    }
    await init();
  }
}
