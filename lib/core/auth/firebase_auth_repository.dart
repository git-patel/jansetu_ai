import 'auth_repository.dart';
import 'auth_service.dart';
import 'current_user.dart';
import 'session_manager.dart';
import 'role_manager.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AuthService authService;
  final SessionManager sessionManager;
  final RoleManager roleManager;

  CurrentUser? _currentUser;
  String? _activeRole;

  FirebaseAuthRepository({
    required this.authService,
    required this.sessionManager,
    required this.roleManager,
  });

  @override
  CurrentUser? get currentUser => _currentUser;

  @override
  String? get activeRole => _activeRole ?? _currentUser?.role;

  @override
  Future<CurrentUser?> loginAnonymously({required String role}) async {
    try {
      final user = await authService.signInAnonymously(role: role);
      _currentUser = user;
      _activeRole = role.toUpperCase();
      await sessionManager.saveSession(user.uid, 'ANON-SESSION-${user.uid}');
      return user;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await authService.signOut();
    await sessionManager.clearSession();
    _currentUser = null;
    _activeRole = null;
  }

  @override
  Future<CurrentUser?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    final hasSession = await sessionManager.hasActiveSession();
    if (!hasSession) return null;
    
    final uid = await sessionManager.getUserUid() ?? 'ANON-RESTORED';
    final timestamp = DateTime.now();
    _currentUser = CurrentUser(
      uid: uid,
      name: 'Restored User',
      email: '',
      role: 'CITIZEN',
      language: 'English',
      state: 'Gujarat',
      district: 'Surat',
      constituency: 'Surat Parliamentary Constituency',
      ward: 'Adajan Ward 14',
      createdAt: timestamp,
      updatedAt: timestamp,
    );
    return _currentUser;
  }

  @override
  Future<bool> hasActiveSession() async {
    return sessionManager.hasActiveSession();
  }
}
