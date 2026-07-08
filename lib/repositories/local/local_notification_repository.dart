import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/logger.dart';
import '../interfaces/notification_repository.dart';

class LocalNotificationRepository implements NotificationRepository {
  static const String _notifKey = 'jansetu_notifications_cache_v1';
  List<Map<String, dynamic>> _notifications = [
    {
      'id': 'ntf-1',
      'title': 'AI Verification Completed',
      'body': 'Grievance ND-2026-SRT-0104 verified by Gemini 2.5 Pro with 98.4% spatial confidence.',
      'category': 'AI_INTELLIGENCE',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      'isRead': false,
    },
    {
      'id': 'ntf-2',
      'title': 'PFMS Tranche 1 Escrow Released',
      'body': '₹60 Lakhs released for flyover construction at Adajan Patia.',
      'category': 'GOVERNANCE_FINANCE',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      'isRead': false,
    },
    {
      'id': 'ntf-3',
      'title': 'MP Sanction Approved',
      'body': 'Hon. C.R. Patil sanctioned ₹1.50 Crore from MPLADS fund.',
      'category': 'PROJECT_SANCTION',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'isRead': true,
    },
  ];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_notifKey)) {
      try {
        final raw = prefs.getString(_notifKey);
        if (raw != null) {
          final decoded = json.decode(raw) as List<dynamic>;
          _notifications = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      } catch (e) {
        JanSetuLogger.error('Failed to decode cached notifications', e, null, 'LocalNotifRepo');
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notifKey, json.encode(_notifications));
  }

  @override
  Future<void> create(Map<String, dynamic> notification) async {
    _notifications.insert(0, notification);
    await _saveToPrefs();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    for (var n in _notifications) {
      if (n['id'] == notificationId) {
        n['isRead'] = true;
        break;
      }
    }
    await _saveToPrefs();
  }

  @override
  Future<void> delete(String notificationId) async {
    _notifications.removeWhere((n) => n['id'] == notificationId);
    await _saveToPrefs();
  }

  @override
  Future<void> markAllRead() async {
    for (var n in _notifications) {
      n['isRead'] = true;
    }
    await _saveToPrefs();
  }

  @override
  List<Map<String, dynamic>> filter({String? category, bool? isRead}) {
    return _notifications.where((n) {
      if (category != null && n['category'] != category) return false;
      if (isRead != null && n['isRead'] != isRead) return false;
      return true;
    }).toList();
  }

  @override
  List<Map<String, dynamic>> search(String query) {
    final q = query.toLowerCase();
    return _notifications.where((n) {
      final t = (n['title'] ?? '').toString().toLowerCase();
      final b = (n['body'] ?? '').toString().toLowerCase();
      return t.contains(q) || b.contains(q);
    }).toList();
  }

  @override
  Map<String, List<Map<String, dynamic>>> getGroupedByDate() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var n in _notifications) {
      final ts = n['timestamp'] as String?;
      String dateKey = 'Today';
      if (ts != null) {
        final date = DateTime.parse(ts);
        final now = DateTime.now();
        if (date.year == now.year && date.month == now.month && date.day == now.day) {
          dateKey = 'Today';
        } else if (now.difference(date).inDays <= 1) {
          dateKey = 'Yesterday';
        } else {
          dateKey = 'Earlier';
        }
      }
      grouped.putIfAbsent(dateKey, () => []).add(n);
    }
    return grouped;
  }
}
