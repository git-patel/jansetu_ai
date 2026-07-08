import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/logger.dart';
import '../interfaces/comment_repository.dart';

class LocalCommentRepository implements CommentRepository {
  static const String _commentsKey = 'jansetu_comments_cache_v1';
  final Map<String, List<Map<String, dynamic>>> _threads = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_commentsKey)) {
      try {
        final raw = prefs.getString(_commentsKey);
        if (raw != null) {
          final decoded = json.decode(raw) as Map<String, dynamic>;
          decoded.forEach((key, value) {
            _threads[key] = (value as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          });
        }
      } catch (e) {
        JanSetuLogger.error('Failed to decode cached comments', e, null, 'LocalCommentRepo');
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_commentsKey, json.encode(_threads));
  }

  @override
  Future<void> add(String targetId, Map<String, dynamic> comment) async {
    final list = _threads.putIfAbsent(targetId, () => []);
    list.add(comment);
    await _saveToPrefs();
    JanSetuLogger.info('Added comment to $targetId', 'LocalCommentRepo');
  }

  @override
  Future<void> reply(String targetId, String parentCommentId, Map<String, dynamic> replyComment) async {
    final list = _threads[targetId] ?? [];
    for (var c in list) {
      if (c['id'] == parentCommentId) {
        final replies = List<Map<String, dynamic>>.from(c['replies'] ?? []);
        replies.add(replyComment);
        c['replies'] = replies;
        break;
      }
    }
    await _saveToPrefs();
  }

  @override
  Future<void> edit(String targetId, String commentId, String newContent) async {
    final list = _threads[targetId] ?? [];
    for (var c in list) {
      if (c['id'] == commentId) {
        c['content'] = newContent;
        c['edited'] = true;
        break;
      }
    }
    await _saveToPrefs();
  }

  @override
  Future<void> delete(String targetId, String commentId) async {
    final list = _threads[targetId] ?? [];
    list.removeWhere((c) => c['id'] == commentId);
    await _saveToPrefs();
  }

  @override
  Future<void> like(String targetId, String commentId) async {
    final list = _threads[targetId] ?? [];
    for (var c in list) {
      if (c['id'] == commentId) {
        c['likes'] = ((c['likes'] ?? 0) as int) + 1;
        break;
      }
    }
    await _saveToPrefs();
  }

  @override
  Future<void> report(String targetId, String commentId, String reason) async {
    JanSetuLogger.warning('Comment $commentId reported for $reason', 'LocalCommentRepo');
  }

  @override
  Future<List<Map<String, dynamic>>> getPaginated(String targetId, {int page = 1, int limit = 20}) async {
    final list = _threads[targetId] ?? [];
    final start = (page - 1) * limit;
    if (start >= list.length) return [];
    final end = (start + limit).clamp(0, list.length);
    return list.sublist(start, end);
  }
}
