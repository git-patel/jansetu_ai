import 'current_user.dart';

abstract class AuthRepository {
  Future<CurrentUser?> loginAnonymously({required String role});
  Future<void> logout();
  Future<CurrentUser?> getCurrentUser();
  Future<bool> hasActiveSession();
  
  String? get activeRole;
  CurrentUser? get currentUser;
}
