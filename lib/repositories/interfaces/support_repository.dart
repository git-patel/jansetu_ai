/// Support (Upvoting & Corroboration) Repository Interface
/// Enforces One User = One Support rule per Prompt 14.
abstract class SupportRepository {
  Future<bool> toggleSupport(String targetId, String userId);
  Future<int> getSupportCount(String targetId);
  Future<bool> isSupportedByUser(String targetId, String userId);
  Stream<int> realtimeStreamPlaceholder(String targetId);
}
