import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;

  _CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}

/// Cache Manager (CacheManager)
/// Implements dual-layer caching (Memory + SharedPreferences Persistence),
/// Time-To-Live (TTL) expiration, automatic invalidation, and offline retry queues.
class CacheManager {
  static final Map<String, _CacheEntry> _memoryCache = {};
  static final List<Map<String, dynamic>> _offlineQueue = [];
  static const Duration defaultTtl = Duration(minutes: 30);

  /// Put data into memory cache with TTL
  static void putMemory<T>(String key, T data, {Duration ttl = defaultTtl}) {
    _memoryCache[key] = _CacheEntry(
      data: data,
      expiry: DateTime.now().add(ttl),
    );
    JanSetuLogger.info('Cached in memory: $key (TTL: ${ttl.inMinutes}m)', 'CacheManager');
  }

  /// Get data from memory cache if valid
  static T? getMemory<T>(String key) {
    final entry = _memoryCache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _memoryCache.remove(key);
      JanSetuLogger.info('Memory cache expired and removed: $key', 'CacheManager');
      return null;
    }
    return entry.data as T?;
  }

  /// Remove item from memory cache
  static void invalidateMemory(String key) {
    _memoryCache.remove(key);
    JanSetuLogger.info('Invalidated memory key: $key', 'CacheManager');
  }

  /// Put serialized data into SharedPreferences with TTL metadata
  static Future<void> putPersistent(String key, dynamic serializedData, {Duration ttl = defaultTtl}) async {
    final prefs = await SharedPreferences.getInstance();
    final wrapper = {
      'data': serializedData,
      'expiry': DateTime.now().add(ttl).toIso8601String(),
    };
    await prefs.setString(key, json.encode(wrapper));
    JanSetuLogger.info('Persisted cache: $key', 'CacheManager');
  }

  /// Get data from SharedPreferences if not expired
  static Future<dynamic> getPersistent(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;

    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final expiryStr = decoded['expiry'] as String?;
      if (expiryStr != null) {
        final expiry = DateTime.parse(expiryStr);
        if (DateTime.now().isAfter(expiry)) {
          await prefs.remove(key);
          JanSetuLogger.info('Persistent cache expired and removed: $key', 'CacheManager');
          return null;
        }
      }
      return decoded['data'];
    } catch (e) {
      JanSetuLogger.error('Failed to parse persistent cache for key $key', e, null, 'CacheManager');
      return null;
    }
  }

  /// Invalidate persistent key
  static Future<void> invalidatePersistent(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    JanSetuLogger.info('Invalidated persistent key: $key', 'CacheManager');
  }

  /// Enqueue an action when offline for later background retry
  static void enqueueOfflineAction(String actionType, Map<String, dynamic> payload) {
    _offlineQueue.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'action': actionType,
      'payload': payload,
      'timestamp': DateTime.now().toIso8601String(),
    });
    JanSetuLogger.warning('Action queued offline: $actionType (Queue Size: ${_offlineQueue.length})', 'CacheManager');
  }

  /// Get unmodifiable copy of offline queue
  static List<Map<String, dynamic>> get offlineQueue => List.unmodifiable(_offlineQueue);

  /// Clear offline queue
  static void clearOfflineQueue() {
    _offlineQueue.clear();
  }

  /// Attempt to retry queued offline actions
  static Future<int> retryOfflineQueue(Future<bool> Function(String action, Map<String, dynamic> payload) handler) async {
    if (_offlineQueue.isEmpty) return 0;
    JanSetuLogger.info('Retrying ${_offlineQueue.length} offline actions...', 'CacheManager');
    
    int processed = 0;
    final List<Map<String, dynamic>> remaining = [];

    for (final item in _offlineQueue) {
      final success = await handler(item['action'] as String, item['payload'] as Map<String, dynamic>);
      if (success) {
        processed++;
      } else {
        remaining.add(item);
      }
    }

    _offlineQueue.clear();
    _offlineQueue.addAll(remaining);
    JanSetuLogger.success('Processed $processed offline actions ($remaining remaining)', 'CacheManager');
    return processed;
  }

  /// Clear all memory and persistent caches
  static Future<void> clearAll() async {
    _memoryCache.clear();
    _offlineQueue.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    JanSetuLogger.warning('All caches cleared', 'CacheManager');
  }
}
