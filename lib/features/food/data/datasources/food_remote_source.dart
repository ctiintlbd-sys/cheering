import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../../domain/entities/restaurant_query_params.dart';
import '../models/home_feed_model.dart';
import '../models/restaurant_model.dart';
import '../models/menu_model.dart';
import '../models/category_model.dart';

class FoodRemoteSource {
  final IApiClient _apiClient;

  FoodRemoteSource(this._apiClient);

  Future<ApiResult<HomeFeedModel>> getHomeFeed({
    double? lat,
    double? lng,
  }) async {
    final query = <String, dynamic>{};
    if (lat != null) query['lat'] = lat;
    if (lng != null) query['lng'] = lng;

    return _apiClient.get<HomeFeedModel>(
      ApiEndpoints.homeFeed,
      queryParameters: query.isNotEmpty ? query : null,
      fromJson: (json) => HomeFeedModel.fromJson(json['data'] ?? {}),
      requiresAuth: false,
    );
  }

  Future<ApiResult<List<RestaurantModel>>> getRestaurants(
    RestaurantQueryParams params,
  ) async {
    return _apiClient.get<List<RestaurantModel>>(
      ApiEndpoints.restaurants,
      queryParameters: params.toMap(),
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      requiresAuth: false,
    );
  }

  Future<ApiResult<RestaurantModel>> getRestaurantDetails(
    String restaurantId, {
    double? lat,
    double? lng,
  }) async {
    final query = <String, dynamic>{};
    if (lat != null) query['lat'] = lat;
    if (lng != null) query['lng'] = lng;

    return _apiClient.get<RestaurantModel>(
      ApiEndpoints.restaurantDetails(restaurantId),
      queryParameters: query.isNotEmpty ? query : null,
      fromJson: (json) => RestaurantModel.fromJson(json['data'] ?? {}),
      requiresAuth: false,
    );
  }

  Future<ApiResult<List<MenuCategoryModel>>> getRestaurantMenu(
    String restaurantId,
  ) async {
    return _apiClient.get<List<MenuCategoryModel>>(
      ApiEndpoints.restaurantMenu(restaurantId),
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => MenuCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      requiresAuth: false,
    );
  }

  Future<ApiResult<List<CategoryModel>>> getCategories() async {
    return _apiClient.get<List<CategoryModel>>(
      ApiEndpoints.categories,
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      requiresAuth: false,
    );
  }
}
