import 'current_user.dart';

abstract class AuthService {
  Future<CurrentUser> signInAnonymously({required String role});
  Future<void> signOut();
  Future<CurrentUser?> getCurrentUser();
  Future<bool> hasSession();
}

class FirebaseAuthService implements AuthService {
  // Simulates/wraps Firebase Auth anonymous login
  @override
  Future<CurrentUser> signInAnonymously({required String role}) async {
    final timestamp = DateTime.now();
    final uid = 'FIREBASE-ANON-${timestamp.millisecondsSinceEpoch}';
    return CurrentUser(
      uid: uid,
      name: 'Anonymous $role',
      email: '',
      role: role.toUpperCase(),
      language: 'English',
      state: 'Gujarat',
      district: 'Surat',
      constituency: 'Surat Parliamentary Constituency',
      ward: 'Adajan Ward 14',
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<CurrentUser?> getCurrentUser() async {
    return null;
  }

  @override
  Future<bool> hasSession() async {
    return false;
  }
}
