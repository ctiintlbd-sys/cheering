import '../../domain/repositories/i_food_repository.dart';
import '../../domain/entities/home_feed_entity.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/restaurant_query_params.dart';
import '../../domain/entities/reel_entity.dart';
import '../../domain/entities/reel_query_params.dart';
import '../datasources/food_remote_source.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/cache/cache_service.dart';
import '../../../../core/config/chache_keys.dart';
import '../models/home_feed_model.dart';
import '../models/restaurant_model.dart';
import '../models/category_model.dart';
import '../models/reel_model.dart';

class FoodRepositoryImpl implements IFoodRepository {
  final FoodRemoteSource _remoteSource;
  final CacheService _cache;

  FoodRepositoryImpl(this._remoteSource, this._cache);

  @override
  Stream<HomeFeedEntity> getHomeFeed({double? lat, double? lng}) {
    return _cache.getOrFetch<HomeFeedModel>(
      CacheKeys.homeFeed,
      fromJson: (json) => HomeFeedModel.fromJson(json),
      toJson: (data) => data.toJson(),
      fetch: () => _remoteSource.getHomeFeed(lat: lat, lng: lng),
      ttl: const Duration(minutes: 30),
    );
  }

  @override
  Stream<List<RestaurantEntity>> getRestaurants(RestaurantQueryParams params) {
    return _cache.getOrFetch<List<RestaurantModel>>(
      CacheKeys.restaurants(params.toMap()),
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (list) => {'data': list.map((e) => e.toJson()).toList()},
      fetch: () => _remoteSource.getRestaurants(params),
      ttl: const Duration(minutes: 15),
    );
  }

  @override
  Future<RestaurantEntity> getRestaurantDetails(
    String restaurantId, {
    double? lat,
    double? lng,
  }) async {
    final result = await _remoteSource.getRestaurantDetails(
      restaurantId,
      lat: lat,
      lng: lng,
    );
    return result.fold(onSuccess: (data) => data, onFailure: (e) => throw e);
  }

  @override
  Future<List<MenuCategoryEntity>> getRestaurantMenu(
    String restaurantId,
  ) async {
    final result = await _remoteSource.getRestaurantMenu(restaurantId);
    return result.fold(onSuccess: (data) => data, onFailure: (e) => throw e);
  }

  @override
  Stream<List<CategoryEntity>> getCategories() {
    return _cache.getOrFetch<List<CategoryModel>>(
      CacheKeys.categories,
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (list) => {'data': list.map((e) => e.toJson()).toList()},
      fetch: () => _remoteSource.getCategories(),
      ttl: const Duration(hours: 24),
    );
  }

  @override
  Stream<ReelsResponseEntity> getReels(ReelQueryParams params) {
    return _cache.getOrFetch<ReelsResponseModel>(
      CacheKeys.reels(params.toMap()),
      fromJson: (json) => ReelsResponseModel.fromJson(json),
      toJson: (data) => data.toJson(),
      fetch: () => _remoteSource.getReels(params),
      ttl: const Duration(minutes: 30),
    );
  }
}
