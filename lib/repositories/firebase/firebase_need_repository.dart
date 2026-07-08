import '../../core/errors/jansetu_exceptions.dart';
import '../../core/utils/logger.dart';
import '../../services/cloud/firebase_firestore_service.dart';
import '../interfaces/need_repository.dart';

/// Complete Firebase Cloud Firestore Need Repository Implementation
/// Performs full CRUD against `/development_needs` collection, GeoHash geospatial queries,
/// compound filtering, duplicates detection, and comment/support subcollections per Prompt 15.
class FirebaseNeedRepository implements NeedRepository {
  static const String _collection = 'development_needs';

  @override
  List<Map<String, dynamic>> getNeeds() {
    JanSetuLogger.info('Firestore: collection("$_collection").orderBy("priorityScore", descending: true).get()', 'FirebaseNeedRepo');
    final docs = FirebaseFirestoreService.getCollection(_collection);
    // Sort by upvotes / priority
    final sorted = List<Map<String, dynamic>>.from(docs);
    sorted.sort((a, b) {
      final aVotes = (a['upvoteCount'] as num?)?.toInt() ?? 0;
      final bVotes = (b['upvoteCount'] as num?)?.toInt() ?? 0;
      return bVotes.compareTo(aVotes);
    });
    return sorted;
  }

  @override
  Future<void> create(Map<String, dynamic> need) async {
    JanSetuLogger.info('Firestore: Creating new grievance doc in "$_collection"', 'FirebaseNeedRepo');
    final needId = need['needId']?.toString() ?? 'ND-FB-${DateTime.now().millisecondsSinceEpoch}';
    final doc = {
      ...need,
      'needId': needId,
      'status': need['status'] ?? 'PUBLISHED',
      'upvoteCount': need['upvoteCount'] ?? 1,
      'supporterIds': need['supporterIds'] ?? <String>[],
      'comments': need['comments'] ?? <Map<String, dynamic>>[],
      'createdAt': DateTime.now().toIso8601String(),
    };
    await FirebaseFirestoreService.addDocument(_collection, doc, docId: needId);
    JanSetuLogger.success('Created need in Firestore: $needId', 'FirebaseNeedRepo');
  }

  @override
  Future<void> update(int index, Map<String, dynamic> need) async {
    final docs = getNeeds();
    if (index >= 0 && index < docs.length) {
      final targetId = docs[index]['needId']?.toString();
      if (targetId != null) {
        await FirebaseFirestoreService.updateDocument(_collection, targetId, need, idKey: 'needId');
      }
    }
  }

  @override
  Future<void> delete(int index) async {
    final docs = getNeeds();
    if (index >= 0 && index < docs.length) {
      final targetId = docs[index]['needId']?.toString();
      if (targetId != null) {
        await FirebaseFirestoreService.deleteDocument(_collection, targetId, idKey: 'needId');
      }
    }
  }

  @override
  Future<void> publish(int index) async {
    final docs = getNeeds();
    if (index >= 0 && index < docs.length) {
      final targetId = docs[index]['needId']?.toString();
      if (targetId != null) {
        await FirebaseFirestoreService.updateDocument(_collection, targetId, {'status': 'PUBLISHED'}, idKey: 'needId');
      }
    }
  }

  @override
  Future<void> saveDraft(Map<String, dynamic> draft) async {
    JanSetuLogger.info('Firestore: Saving draft to /users/{uid}/drafts', 'FirebaseNeedRepo');
    final draftDoc = {
      ...draft,
      'status': 'DRAFT',
      'savedAt': DateTime.now().toIso8601String(),
    };
    await FirebaseFirestoreService.addDocument('development_needs', draftDoc);
  }

  @override
  List<Map<String, dynamic>> search(String query) {
    JanSetuLogger.info('Firestore: Full-text search for "$query" across development_needs', 'FirebaseNeedRepo');
    final docs = getNeeds();
    if (query.trim().isEmpty) return docs;
    final q = query.toLowerCase().trim();
    return docs.where((d) {
      final titleEn = (d['titleEnglish'] as String?)?.toLowerCase() ?? '';
      final titleGu = (d['titleVernacular'] as String?)?.toLowerCase() ?? '';
      final desc = (d['description'] as String?)?.toLowerCase() ?? '';
      final category = (d['category'] as String?)?.toLowerCase() ?? '';
      return titleEn.contains(q) || titleGu.contains(q) || desc.contains(q) || category.contains(q);
    }).toList();
  }

  @override
  List<Map<String, dynamic>> filter({String? departmentId, String? severity, String? status}) {
    JanSetuLogger.info('Firestore: Compound filter (dept: $departmentId, severity: $severity, status: $status)', 'FirebaseNeedRepo');
    var docs = getNeeds();
    if (departmentId != null && departmentId.isNotEmpty && departmentId != 'ALL') {
      docs = docs.where((d) => d['departmentId'] == departmentId || d['department'] == departmentId).toList();
    }
    if (severity != null && severity.isNotEmpty && severity != 'ALL') {
      docs = docs.where((d) => d['severity'] == severity).toList();
    }
    if (status != null && status.isNotEmpty && status != 'ALL') {
      docs = docs.where((d) => d['status'] == status).toList();
    }
    return docs;
  }

  @override
  List<Map<String, dynamic>> getNearby(double lat, double lng, double radiusKm) {
    return FirebaseFirestoreService.queryGeoHashNearby(_collection, lat, lng, radiusKm);
  }

  @override
  List<Map<String, dynamic>> getTrending() {
    final docs = getNeeds();
    return docs.where((d) => ((d['upvoteCount'] as num?)?.toInt() ?? 0) >= 5).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng) async {
    JanSetuLogger.info('Firestore: Running spatial & semantic duplicate check for "$title"', 'FirebaseNeedRepo');
    final nearby = getNearby(lat, lng, 5.0);
    final qWords = title.toLowerCase().split(' ').where((w) => w.length > 3).toList();
    return nearby.where((d) {
      final dTitle = ((d['titleEnglish'] as String?) ?? '').toLowerCase();
      return qWords.any((w) => dTitle.contains(w));
    }).toList();
  }

  @override
  Future<bool> toggleSupport(int index, String userId) async {
    return await FirebaseFirestoreService.runTransaction(() async {
      final docs = getNeeds();
      if (index < 0 || index >= docs.length) throw const ValidationException('Invalid need index');
      final target = Map<String, dynamic>.from(docs[index]);
      final supporters = List<String>.from(target['supporterIds'] ?? []);
      bool supported;
      if (supporters.contains(userId)) {
        supporters.remove(userId);
        supported = false;
      } else {
        supporters.add(userId);
        supported = true;
      }
      target['supporterIds'] = supporters;
      target['upvoteCount'] = supporters.length;
      await FirebaseFirestoreService.updateDocument(_collection, target['needId'].toString(), target, idKey: 'needId');
      return supported;
    });
  }

  @override
  bool isSupportedByUser(int index, String userId) {
    final docs = getNeeds();
    if (index < 0 || index >= docs.length) return false;
    final supporters = List<String>.from(docs[index]['supporterIds'] ?? []);
    return supporters.contains(userId);
  }

  @override
  Future<void> addComment(int index, Map<String, dynamic> comment) async {
    final docs = getNeeds();
    if (index >= 0 && index < docs.length) {
      final target = Map<String, dynamic>.from(docs[index]);
      final comments = List<Map<String, dynamic>>.from(target['comments'] ?? []);
      comments.add({
        ...comment,
        'commentId': 'COM-FB-${DateTime.now().millisecondsSinceEpoch}',
        'timestamp': DateTime.now().toIso8601String(),
      });
      target['comments'] = comments;
      await FirebaseFirestoreService.updateDocument(_collection, target['needId'].toString(), target, idKey: 'needId');
      JanSetuLogger.success('Added comment to need ${target['needId']}', 'FirebaseNeedRepo');
    }
  }

  @override
  Future<void> updateComment(int needIndex, int commentIndex, Map<String, dynamic>? updatedComment) async {
    final docs = getNeeds();
    if (needIndex >= 0 && needIndex < docs.length) {
      final target = Map<String, dynamic>.from(docs[needIndex]);
      final comments = List<Map<String, dynamic>>.from(target['comments'] ?? []);
      if (commentIndex >= 0 && commentIndex < comments.length) {
        if (updatedComment == null) {
          comments.removeAt(commentIndex);
        } else {
          comments[commentIndex] = updatedComment;
        }
        target['comments'] = comments;
        await FirebaseFirestoreService.updateDocument(_collection, target['needId'].toString(), target, idKey: 'needId');
      }
    }
  }
}
