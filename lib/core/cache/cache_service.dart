import '../network/api_result.dart';

abstract interface class CacheService {
  Future<void> set<T>(
      String key,
      T data, {
        required Map<String, dynamic> Function(T data) toJson,
        Duration ttl = const Duration(minutes: 30),
      });

  T? get<T>(
      String key, {
        required T Function(Map<String, dynamic> json) fromJson,
      });

  Stream<T> getOrFetch<T>(
      String key, {
        required T Function(Map<String, dynamic> json) fromJson,
        required Map<String, dynamic> Function(T data) toJson,
        required Future<ApiResult<T>> Function() fetch,
        Duration ttl = const Duration(minutes: 30),
        bool skipFetchIfCached = false,
      });

  Future<void> remove(String key);

  Future<void> clear();
}