import '../../../../core/cache/cache_service.dart';
import '../../../../core/config/chache_keys.dart';
import '../../../../core/network/api_result.dart';
import '../../../food/data/models/restaurant_model.dart';
import '../../../food/domain/entities/restaurant_entity.dart';
import '../../domain/entities/favorite_toggle_entity.dart';
import '../../domain/repositories/i_favorites_repository.dart';
import '../datasources/favorites_remote_source.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  final FavoritesRemoteSource _remoteSource;
  final CacheService _cache;

  FavoritesRepositoryImpl(this._remoteSource, this._cache);

  @override
  Stream<List<RestaurantEntity>> getFavorites() {
    return _cache.getOrFetch<List<RestaurantModel>>(
      CacheKeys.favorites,
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (list) => {'data': list.map((e) => e.toJson()).toList()},
      fetch: () => _remoteSource.getFavorites(),
      ttl: const Duration(minutes: 15),
    );
  }

  @override
  Future<FavoriteToggleEntity> toggleFavorite(String restaurantId) async {
    final result = await _remoteSource.toggleFavorite(restaurantId);
    return result.fold(
      onSuccess: (data) async {
        await _cache.remove(CacheKeys.favorites);
        return data;
      },
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<void> clearLocalCache() async {
    await _cache.remove(CacheKeys.favorites);
  }
}
