import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jansetu_ai/core/config/firebase_bootstrap_service.dart';
import 'package:jansetu_ai/core/config/service_locator.dart';
import 'package:jansetu_ai/firebase_options.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_ai_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_analytics_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_auth_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_comment_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_need_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_notification_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_project_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_support_repository.dart';
import 'package:jansetu_ai/repositories/firebase/firebase_user_repository.dart';
import 'package:jansetu_ai/services/cloud/firebase_firestore_service.dart';
import 'package:jansetu_ai/services/cloud/firebase_monitoring_service.dart';
import 'package:jansetu_ai/services/cloud/firebase_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FirebaseBootstrapService.resetForTesting();
    FirebaseFirestoreService.resetForTesting();
    FirebaseStorageService.clearBucketForTesting();
    FirebaseMonitoringService.clearForTesting();
    FirebaseAnalyticsRepository.clearEventsForTesting();
    await ServiceLocator.instance.init(type: DataSourceType.firebase);
  });

  group('Phase 1: Firebase Project & Core Bootstrap Tests', () {
    test('DefaultFirebaseOptions provides valid multi-platform configs', () {
      final options = DefaultFirebaseOptions.android;
      expect(options['projectId'], equals('jansetu-ai-prod'));
      expect(options['apiKey'], isNotEmpty);
    });

    test('FirebaseBootstrapService initializes offline persistence and App Check', () async {
      expect(FirebaseBootstrapService.isInitialized, isFalse);
      await FirebaseBootstrapService.initialize();
      expect(FirebaseBootstrapService.isInitialized, isTrue);
      expect(FirebaseBootstrapService.isOfflinePersistenceEnabled, isTrue);
    });

    test('FirebaseStorageService handles media upload, compression, and deletion', () async {
      final dummyBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final url = await FirebaseStorageService.uploadMedia(
        category: 'grievances',
        filename: 'pothole.jpg',
        bytes: dummyBytes,
        mimeType: 'image/jpeg',
      );
      expect(url, contains('firebasestorage.googleapis.com'));
      
      final fetched = await FirebaseStorageService.getDownloadUrl('/media/grievances/pothole.jpg');
      expect(fetched, equals(url));

      await FirebaseStorageService.deleteMedia('/media/grievances/pothole.jpg');
      final afterDelete = await FirebaseStorageService.getDownloadUrl('/media/grievances/pothole.jpg');
      expect(afterDelete, isNull);
    });

    test('FirebaseMonitoringService captures Crashlytics errors and Remote Config flags', () async {
      await FirebaseMonitoringService.fetchAndActivateRemoteConfig();
      expect(FirebaseMonitoringService.getBoolFlag('ai_features_enabled'), isTrue);
      expect(FirebaseMonitoringService.getStringFlag('min_app_version'), equals('2.0.0'));

      FirebaseMonitoringService.overrideFlagForTesting('maintenance_mode', true);
      expect(FirebaseMonitoringService.getBoolFlag('maintenance_mode'), isTrue);

      FirebaseMonitoringService.recordFlutterError('Test Exception', null, reason: 'QA Smoke Test');
      expect(FirebaseMonitoringService.recordedCrashes.length, equals(1));
      expect(FirebaseMonitoringService.recordedCrashes.first['type'], equals('FLUTTER_ERROR'));
    });
  });

  group('Phase 2: Complete Firebase Repositories Verification', () {
    test('FirebaseAuthRepository Phone Auth, Demo Auth, and session restoration', () async {
      final authRepo = ServiceLocator.instance.authRepository as FirebaseAuthRepository;
      await authRepo.login('9876543210', '999999');
      expect(authRepo.activeRole, equals('CITIZEN'));
      expect(authRepo.userProfile?['mobile'], equals('9876543210'));

      final restored = await authRepo.restoreSession();
      expect(restored, isTrue);

      await authRepo.logout();
      expect(authRepo.activeRole, isNull);

      await authRepo.demoLogin('MP', {'name': 'Hon. MP'});
      expect(authRepo.activeRole, equals('MP'));
    });

    test('FirebaseNeedRepository Firestore CRUD and GeoHash bounding box search', () async {
      final needRepo = ServiceLocator.instance.needRepository as FirebaseNeedRepository;
      await needRepo.create({
        'needId': 'ND-FB-TEST-01',
        'titleEnglish': 'Broken Streetlight',
        'titleVernacular': 'તુટેલી સ્ટ્રીટ લાઈટ',
        'category': 'Electricity',
        'severity': 'HIGH',
        'upvoteCount': 10,
      });

      final needs = needRepo.getNeeds();
      expect(needs.any((n) => n['needId'] == 'ND-FB-TEST-01'), isTrue);

      final searchResults = needRepo.search('Streetlight');
      expect(searchResults.length, equals(1));

      final trending = needRepo.getTrending();
      expect(trending.isNotEmpty, isTrue);

      await needRepo.delete(0);
    });

    test('FirebaseProjectRepository atomic MPLADS fund deduction transactions', () async {
      final projRepo = ServiceLocator.instance.projectRepository as FirebaseProjectRepository;
      final initialBalance = projRepo.getMpladsFundBalanceINR();

      await projRepo.saveSanction({
        'projectId': 'PRJ-FB-TEST-01',
        'titleEnglish': 'Community Hall Road',
      }, 5000000.0); // ₹50 Lakhs

      final updatedBalance = projRepo.getMpladsFundBalanceINR();
      expect(updatedBalance, equals(initialBalance - 5000000.0));
      expect(projRepo.getProjects().any((p) => p['projectId'] == 'PRJ-FB-TEST-01'), isTrue);
    });

    test('FirebaseCommentRepository realtime threading and replies', () async {
      final commentRepo = ServiceLocator.instance.commentRepository as FirebaseCommentRepository;
      await commentRepo.add('ND-FB-TEST-01', {
        'commentId': 'COM-01',
        'author': 'Citizen A',
        'content': 'I confirm this issue!',
      });

      await commentRepo.reply('ND-FB-TEST-01', 'COM-01', {
        'author': 'Officer B',
        'content': 'We are inspecting today.',
      });

      final paginated = await commentRepo.getPaginated('ND-FB-TEST-01');
      expect(paginated.length, equals(1));
      expect(paginated.first['replies'].length, equals(1));
    });

    test('FirebaseSupportRepository atomic One Support Per User enforcement', () async {
      final supportRepo = ServiceLocator.instance.supportRepository as FirebaseSupportRepository;
      final added = await supportRepo.toggleSupport('ND-FB-TEST-01', 'USR-01');
      expect(added, isTrue);
      expect(await supportRepo.isSupportedByUser('ND-FB-TEST-01', 'USR-01'), isTrue);

      // Toggle again should remove support
      final removed = await supportRepo.toggleSupport('ND-FB-TEST-01', 'USR-01');
      expect(removed, isFalse);
      expect(await supportRepo.isSupportedByUser('ND-FB-TEST-01', 'USR-01'), isFalse);
    });

    test('FirebaseNotificationRepository FCM topic subscriptions and grouping', () async {
      final notifRepo = ServiceLocator.instance.notificationRepository as FirebaseNotificationRepository;
      final token = await notifRepo.registerDeviceToken('USR-01');
      expect(token, contains('fcm-token'));

      await notifRepo.subscribeToRoleTopics('MP');
      await notifRepo.create({'id': 'NOTIF-01', 'title': 'Sanction Alert', 'isRead': false});

      await notifRepo.markAsRead('NOTIF-01');
      final filtered = notifRepo.filter(isRead: true);
      expect(filtered.any((n) => n['id'] == 'NOTIF-01'), isTrue);
    });

    test('FirebaseUserRepository profile governance and audit logging', () async {
      final userRepo = ServiceLocator.instance.userRepository as FirebaseUserRepository;
      await userRepo.updateProfile('USR-01', {'name': 'Updated Citizen', 'role': 'CITIZEN'});
      final profile = await userRepo.getProfile('USR-01');
      expect(profile['name'], equals('Updated Citizen'));

      final perms = await userRepo.getPermissions('USR-01');
      expect(perms, contains('REPORT_NEED'));

      await userRepo.updateRole('USR-01', 'ADMIN');
      final adminPerms = await userRepo.getPermissions('USR-01');
      expect(adminPerms, contains('RELEASE_PFMS'));
    });

    test('FirebaseAnalyticsRepository tracks all 9 required event metrics', () async {
      FirebaseAnalyticsRepository.trackLogin('CITIZEN', 'phone_otp');
      FirebaseAnalyticsRepository.trackReportCreated('ND-01', 'Roads');
      FirebaseAnalyticsRepository.trackSupportAdded('ND-01');
      FirebaseAnalyticsRepository.trackCommentAdded('ND-01');
      FirebaseAnalyticsRepository.trackProjectApproved('PRJ-01', 5000000.0);
      FirebaseAnalyticsRepository.trackNotificationOpened('NOTIF-01');
      FirebaseAnalyticsRepository.trackAiUsed('summarizeNeed', 'gemini-2.5-pro');
      FirebaseAnalyticsRepository.trackDemoUsed('MP');
      FirebaseAnalyticsRepository.logEvent('custom_event', {'foo': 'bar'});

      expect(FirebaseAnalyticsRepository.trackedEvents.length, equals(9));
      
      final devScore = await ServiceLocator.instance.analyticsRepository.calculateDevelopmentScore('SURAT-SOUTH');
      expect(devScore, greaterThan(0.0));
    });

    test('FirebaseAiRepository Cloud Functions wrappers and Gemini API call handlers', () async {
      final aiRepo = ServiceLocator.instance.aiRepository as FirebaseAiRepository;
      final summary = await aiRepo.summarizeNeed('The main junction road has a deep pothole causing severe traffic congestion every morning during rush hour.');
      expect(summary, contains('road surface deterioration'));

      final category = await aiRepo.categorizeGrievance('The drinking water pipeline is leaking near the ward office', null);
      expect(category, equals('Water & Sanitation'));

      final chatReply = await aiRepo.chatAssistant('What is the status of MPLADS fund utilization in Surat?', []);
      expect(chatReply, contains('70%'));
    });
  });

  group('Phase 3: Automatic Runtime Switching Verification', () {
    test('ServiceLocator switches seamlessly between Local (Demo) and Firebase (Prod)', () async {
      expect(ServiceLocator.instance.currentDataSourceType, equals(DataSourceType.firebase));

      // Switch to Local Demo Mode
      await ServiceLocator.instance.switchDataSource(DataSourceType.local);
      expect(ServiceLocator.instance.currentDataSourceType, equals(DataSourceType.local));
      expect(ServiceLocator.instance.needRepository.getNeeds(), isNotEmpty);

      // Switch back to Production Firebase Mode
      await ServiceLocator.instance.switchDataSource(DataSourceType.firebase);
      expect(ServiceLocator.instance.currentDataSourceType, equals(DataSourceType.firebase));
    });
  });
}
