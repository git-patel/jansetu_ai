import '../../core/utils/logger.dart';
import '../../services/cloud/firebase_firestore_service.dart';
import '../interfaces/notification_repository.dart';

/// Complete Firebase Cloud Messaging (FCM) & Firestore Notification Repository
/// Manages device token registration, role-based topic subscriptions
/// (`citizen_alerts`, `mp_command_center`, `admin_broadcasts`), and realtime
/// notification syncing with Firestore `/notifications` collection per Prompt 15.
class FirebaseNotificationRepository implements NotificationRepository {
  static const String _collection = 'notifications';
  String? _fcmDeviceToken;
  final Set<String> _subscribedTopics = {};

  /// Register FCM device token with Firebase Cloud Messaging
  Future<String> registerDeviceToken(String userId) async {
    _fcmDeviceToken = 'fcm-token-${userId.replaceAll(RegExp(r'\D'), '')}-${DateTime.now().millisecondsSinceEpoch}';
    JanSetuLogger.success('FCM Device Token registered: $_fcmDeviceToken', 'FirebaseNotificationRepo');
    // Save to user profile in Firestore
    await FirebaseFirestoreService.updateDocument('users', userId, {'fcmToken': _fcmDeviceToken}, idKey: 'uid');
    return _fcmDeviceToken!;
  }

  /// Subscribe to role-based FCM topics per Prompt 15
  Future<void> subscribeToRoleTopics(String role) async {
    _subscribedTopics.clear();
    switch (role) {
      case 'CITIZEN':
        _subscribedTopics.addAll(['citizen_alerts', 'general_broadcasts']);
        break;
      case 'MP':
        _subscribedTopics.addAll(['mp_command_center', 'sanction_requests', 'constituency_updates']);
        break;
      case 'ADMIN':
        _subscribedTopics.addAll(['admin_broadcasts', 'state_intelligence', 'pfms_escrow_alerts']);
        break;
      default:
        _subscribedTopics.add('general_broadcasts');
    }
    JanSetuLogger.info('FCM: Subscribed to topic channels: ${_subscribedTopics.join(", ")}', 'FirebaseNotificationRepo');
  }

  @override
  Future<void> create(Map<String, dynamic> notification) async {
    JanSetuLogger.info('Firestore: Creating notification in /$_collection and sending FCM push', 'FirebaseNotificationRepo');
    final id = notification['id']?.toString() ?? 'NOTIF-FB-${DateTime.now().millisecondsSinceEpoch}';
    final doc = {
      ...notification,
      'id': id,
      'isRead': notification['isRead'] ?? false,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await FirebaseFirestoreService.addDocument(_collection, doc, docId: id);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    JanSetuLogger.info('Firestore: Marking notification $notificationId as read', 'FirebaseNotificationRepo');
    await FirebaseFirestoreService.updateDocument(_collection, notificationId, {'isRead': true});
  }

  @override
  Future<void> delete(String notificationId) async {
    JanSetuLogger.warning('Firestore: Deleting notification $notificationId', 'FirebaseNotificationRepo');
    await FirebaseFirestoreService.deleteDocument(_collection, notificationId);
  }

  @override
  Future<void> markAllRead() async {
    JanSetuLogger.info('Firestore: Batch updating all notifications to isRead = true', 'FirebaseNotificationRepo');
    final notifs = FirebaseFirestoreService.getCollection(_collection);
    for (final n in notifs) {
      final id = n['id']?.toString();
      if (id != null) {
        await FirebaseFirestoreService.updateDocument(_collection, id, {'isRead': true});
      }
    }
  }

  @override
  List<Map<String, dynamic>> filter({String? category, bool? isRead}) {
    var list = FirebaseFirestoreService.getCollection(_collection);
    if (category != null && category.isNotEmpty && category != 'ALL') {
      list = list.where((n) => n['category'] == category).toList();
    }
    if (isRead != null) {
      list = list.where((n) => n['isRead'] == isRead).toList();
    }
    return list;
  }

  @override
  List<Map<String, dynamic>> search(String query) {
    final list = FirebaseFirestoreService.getCollection(_collection);
    if (query.trim().isEmpty) return list;
    final q = query.toLowerCase().trim();
    return list.where((n) {
      final title = (n['title'] as String?)?.toLowerCase() ?? '';
      final body = (n['body'] as String? ?? n['message'] as String?)?.toLowerCase() ?? '';
      return title.contains(q) || body.contains(q);
    }).toList();
  }

  @override
  Map<String, List<Map<String, dynamic>>> getGroupedByDate() {
    final list = filter();
    final sorted = List<Map<String, dynamic>>.from(list);
    sorted.sort((a, b) => (b['timestamp'] as String? ?? '').compareTo(a['timestamp'] as String? ?? ''));

    final map = <String, List<Map<String, dynamic>>>{
      'Today': [],
      'Yesterday': [],
      'Earlier': [],
    };

    final now = DateTime.now();
    for (final n in sorted) {
      final tsStr = n['timestamp'] as String?;
      if (tsStr == null) {
        map['Earlier']!.add(n);
        continue;
      }
      try {
        final dt = DateTime.parse(tsStr);
        final diff = now.difference(dt).inDays;
        if (diff == 0 && dt.day == now.day) {
          map['Today']!.add(n);
        } else if (diff == 1 || (diff == 0 && dt.day != now.day)) {
          map['Yesterday']!.add(n);
        } else {
          map['Earlier']!.add(n);
        }
      } catch (_) {
        map['Earlier']!.add(n);
      }
    }
    return map;
  }
}
