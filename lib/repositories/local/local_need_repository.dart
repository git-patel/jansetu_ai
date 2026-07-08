import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/synthetic_gujarat_data.dart';
import '../../core/utils/logger.dart';
import '../interfaces/need_repository.dart';

class LocalNeedRepository implements NeedRepository {
  static const String _needsKey = 'jansetu_needs_cache_v1';
  List<Map<String, dynamic>> _needs = [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_needsKey)) {
      try {
        final raw = prefs.getString(_needsKey);
        if (raw != null) {
          final decoded = json.decode(raw) as List<dynamic>;
          _needs = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          return;
        }
      } catch (e) {
        JanSetuLogger.error('Failed to decode cached needs', e, null, 'LocalNeedRepo');
      }
    }
    _needs = List.from(SyntheticGujaratData.fallbackNeeds.map((e) => Map<String, dynamic>.from(e)));
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_needsKey, json.encode(_needs));
  }

  @override
  List<Map<String, dynamic>> getNeeds() => _needs;

  @override
  Future<void> create(Map<String, dynamic> need) async {
    _needs.insert(0, need);
    await _saveToPrefs();
    JanSetuLogger.success('Created new need: ${need['needId']}', 'LocalNeedRepo');
  }

  @override
  Future<void> update(int index, Map<String, dynamic> need) async {
    if (index >= 0 && index < _needs.length) {
      _needs[index] = need;
      await _saveToPrefs();
    }
  }

  @override
  Future<void> delete(int index) async {
    if (index >= 0 && index < _needs.length) {
      final removed = _needs.removeAt(index);
      await _saveToPrefs();
      JanSetuLogger.warning('Deleted need: ${removed['needId']}', 'LocalNeedRepo');
    }
  }

  @override
  Future<void> publish(int index) async {
    if (index >= 0 && index < _needs.length) {
      _needs[index]['status'] = 'PUBLISHED';
      await _saveToPrefs();
    }
  }

  @override
  Future<void> saveDraft(Map<String, dynamic> draft) async {
    draft['status'] = 'DRAFT';
    await create(draft);
  }

  @override
  List<Map<String, dynamic>> search(String query) {
    if (query.trim().isEmpty) return _needs;
    final q = query.toLowerCase();
    return _needs.where((n) {
      final title = (n['titleEnglish'] ?? '').toString().toLowerCase();
      final vern = (n['titleVernacular'] ?? '').toString().toLowerCase();
      return title.contains(q) || vern.contains(q);
    }).toList();
  }

  @override
  List<Map<String, dynamic>> filter({String? departmentId, String? severity, String? status}) {
    return _needs.where((n) {
      if (departmentId != null && n['departmentId'] != departmentId) return false;
      if (severity != null && n['severityClass'] != severity) return false;
      if (status != null && n['status'] != status) return false;
      return true;
    }).toList();
  }

  @override
  List<Map<String, dynamic>> getNearby(double lat, double lng, double radiusKm) {
    return _needs; // Return all needs in local demo sandbox
  }

  @override
  List<Map<String, dynamic>> getTrending() {
    final sorted = List<Map<String, dynamic>>.from(_needs);
    sorted.sort((a, b) => ((b['upvoteCount'] ?? 0) as int).compareTo((a['upvoteCount'] ?? 0) as int));
    return sorted;
  }

  @override
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng) async {
    return _needs.where((n) => (n['priorityScore'] ?? 0) > 85.0).toList();
  }

  @override
  Future<bool> toggleSupport(int index, String userId) async {
    if (index >= 0 && index < _needs.length) {
      final need = _needs[index];
      final supporterIds = List<String>.from(need['supporterIds'] ?? []);
      int upvoteCount = (need['upvoteCount'] ?? 0) as int;
      bool isSupported;

      if (supporterIds.contains(userId)) {
        supporterIds.remove(userId);
        upvoteCount = (upvoteCount - 1).clamp(0, 999999);
        isSupported = false;
      } else {
        supporterIds.add(userId);
        upvoteCount += 1;
        isSupported = true;
      }

      need['supporterIds'] = supporterIds;
      need['upvoteCount'] = upvoteCount;
      await _saveToPrefs();
      return isSupported;
    }
    return false;
  }

  @override
  bool isSupportedByUser(int index, String userId) {
    if (index >= 0 && index < _needs.length) {
      final supporterIds = List<String>.from(_needs[index]['supporterIds'] ?? []);
      return supporterIds.contains(userId);
    }
    return false;
  }

  @override
  Future<void> addComment(int index, Map<String, dynamic> comment) async {
    if (index >= 0 && index < _needs.length) {
      final need = _needs[index];
      final comments = List<Map<String, dynamic>>.from(need['comments'] ?? []);
      comments.add(comment);
      need['comments'] = comments;
      need['commentCount'] = comments.length;
      await _saveToPrefs();
    }
  }

  @override
  Future<void> updateComment(int needIndex, int commentIndex, Map<String, dynamic>? updatedComment) async {
    if (needIndex >= 0 && needIndex < _needs.length) {
      final need = _needs[needIndex];
      final comments = List<Map<String, dynamic>>.from(need['comments'] ?? []);
      if (commentIndex >= 0 && commentIndex < comments.length) {
        if (updatedComment == null) {
          comments.removeAt(commentIndex);
        } else {
          comments[commentIndex] = updatedComment;
        }
        need['comments'] = comments;
        need['commentCount'] = comments.length;
        await _saveToPrefs();
      }
    }
  }
}
