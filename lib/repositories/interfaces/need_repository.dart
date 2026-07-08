/// Development Need (Grievance) Repository Interface
/// Manages citizen needs, upvotes, corroborating witnesses, and AI spatial routing ledgers.
abstract class NeedRepository {
  List<Map<String, dynamic>> getNeeds();
  Future<void> create(Map<String, dynamic> need);
  Future<void> update(int index, Map<String, dynamic> need);
  Future<void> delete(int index);
  Future<void> publish(int index);
  Future<void> saveDraft(Map<String, dynamic> draft);
  List<Map<String, dynamic>> search(String query);
  List<Map<String, dynamic>> filter({String? departmentId, String? severity, String? status});
  List<Map<String, dynamic>> getNearby(double lat, double lng, double radiusKm);
  List<Map<String, dynamic>> getTrending();
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng);
  Future<bool> toggleSupport(int index, String userId);
  bool isSupportedByUser(int index, String userId);
  Future<void> addComment(int index, Map<String, dynamic> comment);
  Future<void> updateComment(int needIndex, int commentIndex, Map<String, dynamic>? updatedComment);
}
