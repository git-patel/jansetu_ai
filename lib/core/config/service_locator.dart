import '../../repositories/interfaces/ai_repository.dart';
import '../../repositories/interfaces/analytics_repository.dart';
import '../../repositories/interfaces/auth_repository.dart';
import '../../repositories/interfaces/comment_repository.dart';
import '../../repositories/interfaces/need_repository.dart';
import '../../repositories/interfaces/notification_repository.dart';
import '../../repositories/interfaces/project_repository.dart';
import '../../repositories/interfaces/support_repository.dart';
import '../../repositories/interfaces/user_repository.dart';

import '../../repositories/local/local_ai_repository.dart';
import '../../repositories/local/local_analytics_repository.dart';
import '../../repositories/local/local_auth_repository.dart';
import '../../repositories/local/local_comment_repository.dart';
import '../../repositories/local/local_need_repository.dart';
import '../../repositories/local/local_notification_repository.dart';
import '../../repositories/local/local_project_repository.dart';
import '../../repositories/local/local_support_repository.dart';
import '../../repositories/local/local_user_repository.dart';

import '../../repositories/firebase/firebase_ai_repository.dart';
import '../../repositories/firebase/firebase_analytics_repository.dart';
import '../../repositories/firebase/firebase_auth_repository.dart';
import '../../repositories/firebase/firebase_comment_repository.dart';
import '../../repositories/firebase/firebase_need_repository.dart';
import '../../repositories/firebase/firebase_notification_repository.dart';
import '../../repositories/firebase/firebase_project_repository.dart';
import '../../repositories/firebase/firebase_support_repository.dart';
import '../../repositories/firebase/firebase_user_repository.dart';

import '../utils/logger.dart';

// Clean Architecture Core AI & Auth Modules (Prompt 18)
import '../ai/ai_repository.dart' as core_ai;
import '../ai/ai_repository_impl.dart' as core_ai_impl;
import '../ai/gemini_ai_service.dart' as core_gemini;
import '../ai/mock_ai_service.dart' as core_mock;
import '../auth/auth_repository.dart' as core_auth;
import '../auth/firebase_auth_repository.dart' as core_auth_impl;
import '../auth/auth_service.dart' as core_auth_service;
import '../auth/session_manager.dart' as core_session;
import '../auth/role_manager.dart' as core_role;

enum DataSourceType { local, firebase }

/// Central Service Locator & Dependency Injection Registry (ServiceLocator)
/// Manages singleton instances of all repository interfaces and enables
/// 1-click runtime switching between offline demo sandbox (Local) and production cloud (Firebase).
class ServiceLocator {
  static final ServiceLocator instance = ServiceLocator._internal();
  ServiceLocator._internal() {
    authRepository = LocalAuthRepository();
    needRepository = LocalNeedRepository();
    projectRepository = LocalProjectRepository();
    commentRepository = LocalCommentRepository();
    supportRepository = LocalSupportRepository();
    notificationRepository = LocalNotificationRepository();
    userRepository = LocalUserRepository();
    analyticsRepository = LocalAnalyticsRepository();
    aiRepository = LocalAiRepository();

    // Register Clean Architecture Core Modules (Prompt 18)
    final mockAi = core_mock.MockAIService();
    final geminiAi = core_gemini.GeminiAIService();
    coreAiRepository = core_ai_impl.AIRepositoryImpl(
      geminiService: geminiAi,
      mockService: mockAi,
    );

    final sessionMgr = core_session.SessionManager();
    final roleMgr = core_role.RoleManager();
    final authServ = core_auth_service.FirebaseAuthService();
    coreAuthRepository = core_auth_impl.FirebaseAuthRepository(
      authService: authServ,
      sessionManager: sessionMgr,
      roleManager: roleMgr,
    );
  }

  DataSourceType _currentType = DataSourceType.local;
  DataSourceType get currentDataSourceType => _currentType;

  late AuthRepository authRepository;
  late NeedRepository needRepository;
  late ProjectRepository projectRepository;
  late CommentRepository commentRepository;
  late SupportRepository supportRepository;
  late NotificationRepository notificationRepository;
  late UserRepository userRepository;
  late AnalyticsRepository analyticsRepository;
  late AiRepository aiRepository;

  // Clean Architecture Core Repositories
  late core_ai.AIRepository coreAiRepository;
  late core_auth.AuthRepository coreAuthRepository;

  /// Initialize repositories for the specified data source type
  Future<void> init({DataSourceType type = DataSourceType.local}) async {
    _currentType = type;
    JanSetuLogger.warning('Initializing ServiceLocator with data source: ${_currentType.name}', 'ServiceLocator');

    if (type == DataSourceType.local) {
      final localAuth = LocalAuthRepository();
      final localNeed = LocalNeedRepository();
      final localProject = LocalProjectRepository();
      final localComment = LocalCommentRepository();
      final localSupport = LocalSupportRepository();
      final localNotif = LocalNotificationRepository();
      final localUser = LocalUserRepository();
      final localAnalytics = LocalAnalyticsRepository();
      final localAi = LocalAiRepository();

      await localNeed.init();
      await localProject.init();
      await localComment.init();
      await localSupport.init();
      await localNotif.init();
      await localUser.init();
      await localAuth.restoreSession();

      authRepository = localAuth;
      needRepository = localNeed;
      projectRepository = localProject;
      commentRepository = localComment;
      supportRepository = localSupport;
      notificationRepository = localNotif;
      userRepository = localUser;
      analyticsRepository = localAnalytics;
      aiRepository = localAi;
    } else {
      authRepository = FirebaseAuthRepository();
      needRepository = FirebaseNeedRepository();
      projectRepository = FirebaseProjectRepository();
      commentRepository = FirebaseCommentRepository();
      supportRepository = FirebaseSupportRepository();
      notificationRepository = FirebaseNotificationRepository();
      userRepository = FirebaseUserRepository();
      analyticsRepository = FirebaseAnalyticsRepository();
      aiRepository = FirebaseAiRepository();
    }

    JanSetuLogger.success('ServiceLocator initialization completed for ${_currentType.name}', 'ServiceLocator');
  }

  /// Switch data source at runtime
  Future<void> switchDataSource(DataSourceType newType) async {
    await init(type: newType);
  }
}
