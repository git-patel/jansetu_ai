import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/logger.dart';
import '../interfaces/user_repository.dart';

class LocalUserRepository implements UserRepository {
  static const String _usersKey = 'jansetu_users_cache_v1';
  final Map<String, Map<String, dynamic>> _usersMap = {
    'CIT-SRT-8841': {
      'name': 'Rajesh Bhai Patel',
      'id': 'CIT-SRT-8841',
      'role': 'CITIZEN',
      'jurisdiction': 'WRD-GUJ-SRT-0014',
      'wardName': 'Adajan Ward 14',
      'city': 'Surat',
      'lang': 'English',
      'permissions': ['REPORT_NEED', 'UPVOTE', 'COMMENT', 'VIEW_WARD'],
    },
    'USR-MP-CR-PATIL': {
      'name': 'Hon. C.R. Patil',
      'id': 'USR-MP-CR-PATIL',
      'role': 'MP',
      'jurisdiction': 'CONST-GUJ-NAV-001',
      'constituencyName': 'Navsari Parliamentary Constituency',
      'lang': 'English',
      'permissions': ['SANCTION_MPLADS', 'VIEW_CONSTITUENCY', 'COMMENT', 'APPROVE'],
    },
    'USR-ADMIN-HQ-001': {
      'name': 'Shri K.L. Mehta, IAS',
      'id': 'USR-ADMIN-HQ-001',
      'role': 'ADMIN',
      'jurisdiction': 'STATE-GUJ',
      'stateName': 'Gujarat State Secretariat',
      'lang': 'English',
      'permissions': ['RELEASE_PFMS', 'UNIVERSAL_ADMIN', 'VIEW_ALL', 'AUDIT'],
    },
  };

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_usersKey)) {
      try {
        final raw = prefs.getString(_usersKey);
        if (raw != null) {
          final decoded = json.decode(raw) as Map<String, dynamic>;
          decoded.forEach((k, v) => _usersMap[k] = Map<String, dynamic>.from(v as Map));
        }
      } catch (e) {
        JanSetuLogger.error('Failed to decode user cache', e, null, 'LocalUserRepo');
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(_usersMap));
  }

  @override
  Future<Map<String, dynamic>> getProfile(String userId) async {
    return _usersMap[userId] ?? {
      'id': userId,
      'name': 'Demo User ($userId)',
      'role': 'CITIZEN',
      'jurisdiction': 'WRD-GUJ-SRT-0014',
      'permissions': ['REPORT_NEED', 'UPVOTE', 'COMMENT'],
    };
  }

  @override
  Future<void> updateProfile(String userId, Map<String, dynamic> updatedData) async {
    final user = _usersMap.putIfAbsent(userId, () => {});
    user.addAll(updatedData);
    await _saveToPrefs();
  }

  @override
  Future<Map<String, dynamic>> getJurisdictionArea(String areaCode) async {
    return {
      'areaCode': areaCode,
      'name': areaCode == 'WRD-GUJ-SRT-0014' ? 'Adajan Ward 14, Surat' : 'Gujarat Jurisdiction $areaCode',
      'population': 142000,
      'activeProjects': 18,
      'budgetAllocatedINR': 45000000.0,
    };
  }

  @override
  Future<List<String>> getPermissions(String userId) async {
    final user = _usersMap[userId];
    if (user != null && user['permissions'] != null) {
      return List<String>.from(user['permissions'] as List);
    }
    return ['REPORT_NEED', 'UPVOTE', 'COMMENT'];
  }

  @override
  Future<void> setLanguage(String userId, String langCode) async {
    final user = _usersMap.putIfAbsent(userId, () => {});
    user['lang'] = langCode;
    await _saveToPrefs();
  }

  @override
  Future<void> updateRole(String userId, String newRole) async {
    final user = _usersMap.putIfAbsent(userId, () => {});
    user['role'] = newRole;
    await _saveToPrefs();
  }

  @override
  Future<void> updateSettings(String userId, Map<String, dynamic> settings) async {
    final user = _usersMap.putIfAbsent(userId, () => {});
    user['settings'] = settings;
    await _saveToPrefs();
  }
}
