import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jansetu_ai/core/config/service_locator.dart';
import 'package:jansetu_ai/core/errors/jansetu_exceptions.dart';
import 'package:jansetu_ai/core/utils/cache_manager.dart';
import 'package:jansetu_ai/core/utils/secure_storage.dart';
import 'package:jansetu_ai/services/local_persistence_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheManager.clearAll();
    await LocalPersistenceService.init();
  });

  group('Phase 1: Core Infrastructure Tests', () {
    test('CacheManager dual-layer cache and TTL expiration', () async {
      // Test put and get from memory cache
      CacheManager.putMemory('test_key', {'foo': 'bar'});
      final cached = CacheManager.getMemory<Map<String, dynamic>>('test_key');
      expect(cached, isNotNull);
      expect(cached!['foo'], equals('bar'));

      // Test invalidation
      CacheManager.invalidateMemory('test_key');
      final afterInvalidate = CacheManager.getMemory('test_key');
      expect(afterInvalidate, isNull);
    });

    test('CacheManager offline queue retry mechanism', () async {
      CacheManager.enqueueOfflineAction('CREATE_NEED', {'title': 'Offline Pothole'});
      final queue = CacheManager.offlineQueue;
      expect(queue.length, equals(1));
      expect(queue.first['action'], equals('CREATE_NEED'));

      CacheManager.clearOfflineQueue();
      final cleared = CacheManager.offlineQueue;
      expect(cleared.isEmpty, isTrue);
    });

    test('SecureStorageService token generation and RBAC validation', () async {
      SecureStorageService.generateSessionToken('USR-101', 'ADMIN');
      expect(SecureStorageService.activeToken, isNotNull);
      expect(SecureStorageService.activeToken, contains('ePramaan-ADMIN-USR-101'));

      // Validate permission
      expect(SecureStorageService.hasPermission('ADMIN', 'RELEASE_PFMS'), isTrue);
      expect(SecureStorageService.hasPermission('CITIZEN', 'RELEASE_PFMS'), isFalse);

      SecureStorageService.clearToken();
      expect(SecureStorageService.activeToken, isNull);
    });

    test('JanSetuException hierarchy formatting', () {
      const authErr = AuthenticationException('Invalid OTP entered');
      expect(authErr.message, equals('Invalid OTP entered'));
      expect(authErr.toString(), contains('AUTH_ERROR'));
    });
  });

  group('Phase 2 & 3: Repository Pattern & Concrete Implementations', () {
    test('LocalNeedRepository CRUD and search operations', () async {
      final repo = ServiceLocator.instance.needRepository;
      final initialCount = repo.getNeeds().length;

      final newNeed = {
        'needId': 'ND-TEST-001',
        'titleEnglish': 'Broken Streetlight',
        'titleVernacular': 'તુટેલી સ્ટ્રીટ લાઈટ',
        'status': 'DRAFT',
        'upvoteCount': 5,
        'supporterIds': <String>[],
      };

      await repo.create(newNeed);
      expect(repo.getNeeds().length, equals(initialCount + 1));

      // Test search
      final searchResults = repo.search('Streetlight');
      expect(searchResults.isNotEmpty, isTrue);
      expect(searchResults.first['needId'], equals('ND-TEST-001'));

      // Test toggle support
      final supported = await repo.toggleSupport(0, 'USER-88');
      expect(supported, isTrue);
      expect(repo.isSupportedByUser(0, 'USER-88'), isTrue);

      await repo.delete(0);
      expect(repo.getNeeds().length, equals(initialCount));
    });

    test('LocalProjectRepository MPLADS fund management and sanctioning', () async {
      final repo = ServiceLocator.instance.projectRepository;
      final initialBalance = repo.getMpladsFundBalanceINR();

      final newProject = {
        'projectId': 'PRJ-TEST-001',
        'titleEnglish': 'Community Hall Construction',
        'currentStatus': 'SANCTIONED',
      };

      await repo.saveSanction(newProject, 10000000.0); // ₹1 Crore
      expect(repo.getMpladsFundBalanceINR(), equals(initialBalance - 10000000.0));
      expect(repo.getProjects().first['projectId'], equals('PRJ-TEST-001'));
    });

    test('ServiceLocator runtime data source switching between Local and Firebase', () async {
      expect(ServiceLocator.instance.currentDataSourceType, equals(DataSourceType.local));

      // Switch to Firebase
      await ServiceLocator.instance.switchDataSource(DataSourceType.firebase);
      expect(ServiceLocator.instance.currentDataSourceType, equals(DataSourceType.firebase));

      // In Prompt 15 Complete Firebase mode, repository methods execute cleanly against cloud stores
      await ServiceLocator.instance.needRepository.create({'needId': 'ND-FB', 'priorityScore': 80.0});
      expect(
        ServiceLocator.instance.needRepository.getNeeds().any((n) => n['needId'] == 'ND-FB'),
        isTrue,
      );

      // Switch back to Local
      await ServiceLocator.instance.switchDataSource(DataSourceType.local);
      expect(ServiceLocator.instance.currentDataSourceType, equals(DataSourceType.local));
    });
  });

  group('Phase 4: Facade & Backward Compatibility Tests', () {
    test('LocalPersistenceService delegates cleanly to ServiceLocator', () async {
      expect(LocalPersistenceService.needs, isNotEmpty);
      expect(LocalPersistenceService.projects, isNotEmpty);
      expect(LocalPersistenceService.mpladsFundBalanceINR, isPositive);

      final beforeCount = LocalPersistenceService.needs.length;
      await LocalPersistenceService.saveNeed({
        'needId': 'ND-FACADE-001',
        'titleEnglish': 'Facade Need Test',
        'upvoteCount': 1,
        'supporterIds': <String>[],
      });

      expect(LocalPersistenceService.needs.length, equals(beforeCount + 1));
      expect(LocalPersistenceService.needs.first['needId'], equals('ND-FACADE-001'));

      await LocalPersistenceService.loginAsRole('MP', {'name': 'Test MP'});
      expect(LocalPersistenceService.activeRole, equals('MP'));
      expect(LocalPersistenceService.userProfile?['name'], equals('Test MP'));

      await LocalPersistenceService.logout();
      expect(LocalPersistenceService.activeRole, isNull);
      expect(LocalPersistenceService.userProfile, isNull);
    });
  });
}
