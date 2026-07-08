import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/logger.dart';
import '../interfaces/support_repository.dart';

class LocalSupportRepository implements SupportRepository {
  static const String _supportKey = 'jansetu_support_cache_v1';
  final Map<String, Set<String>> _supportMap = {};
  final Map<String, StreamController<int>> _streamControllers = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_supportKey)) {
      try {
        final raw = prefs.getString(_supportKey);
        if (raw != null) {
          final decoded = json.decode(raw) as Map<String, dynamic>;
          decoded.forEach((key, value) {
            _supportMap[key] = Set<String>.from(value as List);
          });
        }
      } catch (e) {
        JanSetuLogger.error('Failed to decode support cache', e, null, 'LocalSupportRepo');
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final serializable = <String, List<String>>{};
    _supportMap.forEach((key, value) => serializable[key] = value.toList());
    await prefs.setString(_supportKey, json.encode(serializable));
  }

  @override
  Future<bool> toggleSupport(String targetId, String userId) async {
    final set = _supportMap.putIfAbsent(targetId, () => {});
    bool added;
    if (set.contains(userId)) {
      set.remove(userId);
      added = false;
    } else {
      set.add(userId);
      added = true;
    }
    await _saveToPrefs();
    if (_streamControllers.containsKey(targetId)) {
      _streamControllers[targetId]?.add(set.length);
    }
    JanSetuLogger.info('Toggled support for $targetId by $userId -> $added', 'LocalSupportRepo');
    return added;
  }

  @override
  Future<int> getSupportCount(String targetId) async {
    return _supportMap[targetId]?.length ?? 0;
  }

  @override
  Future<bool> isSupportedByUser(String targetId, String userId) async {
    return _supportMap[targetId]?.contains(userId) ?? false;
  }

  @override
  Stream<int> realtimeStreamPlaceholder(String targetId) {
    final controller = _streamControllers.putIfAbsent(targetId, () => StreamController<int>.broadcast());
    Future.microtask(() => controller.add(_supportMap[targetId]?.length ?? 0));
    return controller.stream;
  }
}
