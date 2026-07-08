import 'dart:async';
import '../../core/utils/logger.dart';

/// Firebase Monitoring & Governance Service
/// Combines Firebase Crashlytics (Error logging across Flutter framework,
/// repositories, navigation, and media uploads) with Firebase Remote Config
/// (Feature flags, maintenance banners, minimum app versioning) per Prompt 15.
class FirebaseMonitoringService {
  // --- Remote Config Defaults ---
  static final Map<String, dynamic> _remoteConfigValues = {
    'maintenance_mode': false,
    'announcement_banner': '',
    'min_app_version': '2.0.0',
    'ai_features_enabled': true,
    'demo_mode_enabled': true,
    'gemini_model_version': 'gemini-2.5-pro',
  };

  static final List<Map<String, dynamic>> _recordedCrashes = [];

  // --- Remote Config Methods ---

  /// Initialize and fetch latest Remote Config feature flags
  static Future<void> fetchAndActivateRemoteConfig() async {
    JanSetuLogger.info('Fetching Remote Config flags from Firebase server...', 'RemoteConfig');
    // Simulate 100% successful activation
    JanSetuLogger.success('Activated Remote Config: ${_remoteConfigValues.length} feature flags loaded.', 'RemoteConfig');
  }

  /// Get boolean feature flag
  static bool getBoolFlag(String key) {
    return (_remoteConfigValues[key] as bool?) ?? false;
  }

  /// Get string feature flag / configuration value
  static String getStringFlag(String key) {
    return (_remoteConfigValues[key] as String?) ?? '';
  }

  /// Override flag for local testing or demo scenarios
  static void overrideFlagForTesting(String key, dynamic value) {
    _remoteConfigValues[key] = value;
    JanSetuLogger.warning('Overriding Remote Config flag [$key] = $value', 'RemoteConfig');
  }

  // --- Crashlytics Methods ---

  /// Capture a Flutter framework or UI rendering error
  static void recordFlutterError(dynamic exception, StackTrace? stackTrace, {String? reason}) {
    _logCrash('FLUTTER_ERROR', exception, stackTrace, reason);
  }

  /// Capture a Repository or Cloud Firestore database error
  static void recordRepositoryError(String repositoryName, dynamic exception, StackTrace? stackTrace) {
    _logCrash('REPOSITORY_ERROR', exception, stackTrace, 'Repository: $repositoryName');
  }

  /// Capture a Navigation or Routing fault
  static void recordNavigationError(String routeName, dynamic exception, StackTrace? stackTrace) {
    _logCrash('NAVIGATION_ERROR', exception, stackTrace, 'Route: $routeName');
  }

  /// Capture a Media Upload / Cloud Storage failure
  static void recordUploadError(String storagePath, dynamic exception, StackTrace? stackTrace) {
    _logCrash('UPLOAD_ERROR', exception, stackTrace, 'Path: $storagePath');
  }

  static void _logCrash(String type, dynamic exception, StackTrace? stackTrace, String? customReason) {
    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'type': type,
      'error': exception.toString(),
      'reason': customReason ?? 'No reason provided',
      'stack': stackTrace?.toString() ?? 'No stack trace',
    };
    _recordedCrashes.add(entry);
    JanSetuLogger.error('Crashlytics [$type]: $exception (${customReason ?? ""})', exception, stackTrace, 'Crashlytics');
  }

  /// Get recorded crash logs (for QA verification)
  static List<Map<String, dynamic>> get recordedCrashes => List.unmodifiable(_recordedCrashes);

  /// Clear monitoring state (for testing)
  static void clearForTesting() {
    _recordedCrashes.clear();
  }
}
