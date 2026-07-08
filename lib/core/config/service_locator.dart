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
