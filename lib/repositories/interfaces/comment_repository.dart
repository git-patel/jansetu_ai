/// Comment Repository Interface
/// Manages citizen corroboration comments, officer replies, upvotes, and mentions.
abstract class CommentRepository {
  Future<void> add(String targetId, Map<String, dynamic> comment);
  Future<void> reply(String targetId, String parentCommentId, Map<String, dynamic> replyComment);
  Future<void> edit(String targetId, String commentId, String newContent);
  Future<void> delete(String targetId, String commentId);
  Future<void> like(String targetId, String commentId);
  Future<void> report(String targetId, String commentId, String reason);
  Future<List<Map<String, dynamic>>> getPaginated(String targetId, {int page = 1, int limit = 20});
}
