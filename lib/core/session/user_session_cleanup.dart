import '../cache/cache_service.dart';
import '../storage/token_storage.dart';

/// Clears auth credentials and user-scoped local cache (Hive).
class UserSessionCleanup {
  final CacheService _cache;

  UserSessionCleanup(this._cache);

  Future<void> call() async {
    await TokenStorage.clearTokens();
    await _cache.clear();
  }
}
