import '../../../../core/network/api_result.dart';
import '../../domain/repositories/i_food_repository.dart';
import '../../domain/entities/home_feed_entity.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import '../datasources/food_remote_data_source.dart';

class FoodRepositoryImpl implements IFoodRepository {
  final IFoodRemoteDataSource _remoteDataSource;

  FoodRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<HomeFeedEntity>> getHomeFeed({double? lat, double? lng}) {
    return _remoteDataSource.getHomeFeed(lat: lat, lng: lng);
  }

  @override
  Future<ApiResult<List<RestaurantEntity>>> getRestaurants({
    double? lat,
    double? lng,
    int? radius,
    String? cuisine,
    String? category,
    bool? isOpen,
    String? sort,
    int? maxDeliveryFee,
    double? minRating,
    String? q,
    int limit = 20,
    int offset = 0,
  }) {
    return _remoteDataSource.getRestaurants(
      lat: lat,
      lng: lng,
      radius: radius,
      cuisine: cuisine,
      category: category,
      isOpen: isOpen,
      sort: sort,
      maxDeliveryFee: maxDeliveryFee,
      minRating: minRating,
      q: q,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<ApiResult<RestaurantEntity>> getRestaurantDetails(
    String restaurantId, {
    double? lat,
    double? lng,
  }) {
    return _remoteDataSource.getRestaurantDetails(restaurantId, lat: lat, lng: lng);
  }

  @override
  Future<ApiResult<List<MenuCategoryEntity>>> getRestaurantMenu(String restaurantId) {
    return _remoteDataSource.getRestaurantMenu(restaurantId);
  }

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() {
    return _remoteDataSource.getCategories();
  }

  @override
  Future<ApiResult<SearchResultEntity>> search({
    required String q,
    double? lat,
    double? lng,
    int limit = 20,
    int offset = 0,
    String? sort,
  }) {
    return _remoteDataSource.search(
      q: q,
      lat: lat,
      lng: lng,
      limit: limit,
      offset: offset,
      sort: sort,
    );
  }
}
