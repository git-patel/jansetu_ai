/// Notification Repository Interface
/// Manages real-time AI status updates, officer tranche releases, and citizen alerts.
abstract class NotificationRepository {
  Future<void> create(Map<String, dynamic> notification);
  Future<void> markAsRead(String notificationId);
  Future<void> delete(String notificationId);
  Future<void> markAllRead();
  List<Map<String, dynamic>> filter({String? category, bool? isRead});
  List<Map<String, dynamic>> search(String query);
  Map<String, List<Map<String, dynamic>>> getGroupedByDate();
}
