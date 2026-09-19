import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/home_feed_model.dart';
import '../models/restaurant_model.dart';
import '../models/menu_model.dart';
import '../models/category_model.dart';
import '../models/search_result_model.dart';

abstract class IFoodRemoteDataSource {
  Future<ApiResult<HomeFeedModel>> getHomeFeed({double? lat, double? lng});
  
  Future<ApiResult<List<RestaurantModel>>> getRestaurants({
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
  });

  Future<ApiResult<RestaurantModel>> getRestaurantDetails(
    String restaurantId, {
    double? lat,
    double? lng,
  });

  Future<ApiResult<List<MenuCategoryModel>>> getRestaurantMenu(String restaurantId);

  Future<ApiResult<List<CategoryModel>>> getCategories();

  Future<ApiResult<SearchResultModel>> search({
    required String q,
    double? lat,
    double? lng,
    int limit = 20,
    int offset = 0,
    String? sort,
  });
}

class FoodRemoteDataSourceImpl implements IFoodRemoteDataSource {
  final IApiClient _apiClient;

  FoodRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ApiResult<HomeFeedModel>> getHomeFeed({double? lat, double? lng}) async {
    final query = <String, dynamic>{};
    if (lat != null) query['lat'] = lat;
    if (lng != null) query['lng'] = lng;
    
    return await _apiClient.get<HomeFeedModel>(
      '/api/v1/home/feed',
      queryParameters: query,
      fromJson: (json) => HomeFeedModel.fromJson(json['data'] ?? {}),
      requiresAuth: false,
    );
  }

  @override
  Future<ApiResult<List<RestaurantModel>>> getRestaurants({
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
  }) async {
    final query = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (lat != null) query['lat'] = lat;
    if (lng != null) query['lng'] = lng;
    if (radius != null) query['radius'] = radius;
    if (cuisine != null) query['cuisine'] = cuisine;
    if (category != null) query['category'] = category;
    if (isOpen != null) query['is_open'] = isOpen;
    if (sort != null) query['sort'] = sort;
    if (maxDeliveryFee != null) query['max_delivery_fee'] = maxDeliveryFee;
    if (minRating != null) query['min_rating'] = minRating;
    if (q != null) query['q'] = q;

    return await _apiClient.get<List<RestaurantModel>>(
      '/api/v1/restaurants',
      queryParameters: query,
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data.map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>)).toList();
      },
      requiresAuth: false,
    );
  }

  @override
  Future<ApiResult<RestaurantModel>> getRestaurantDetails(
    String restaurantId, {
    double? lat,
    double? lng,
  }) async {
    final query = <String, dynamic>{};
    if (lat != null) query['lat'] = lat;
    if (lng != null) query['lng'] = lng;

    return await _apiClient.get<RestaurantModel>(
      '/api/v1/restaurants/$restaurantId',
      queryParameters: query,
      fromJson: (json) => RestaurantModel.fromJson(json['data'] ?? {}),
      requiresAuth: false,
    );
  }

  @override
  Future<ApiResult<List<MenuCategoryModel>>> getRestaurantMenu(String restaurantId) async {
    return await _apiClient.get<List<MenuCategoryModel>>(
      '/api/v1/restaurants/$restaurantId/menu',
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data.map((e) => MenuCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      },
      requiresAuth: false,
    );
  }

  @override
  Future<ApiResult<List<CategoryModel>>> getCategories() async {
    return await _apiClient.get<List<CategoryModel>>(
      '/api/v1/categories',
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      },
      requiresAuth: false,
    );
  }

  @override
  Future<ApiResult<SearchResultModel>> search({
    required String q,
    double? lat,
    double? lng,
    int limit = 20,
    int offset = 0,
    String? sort,
  }) async {
    final query = <String, dynamic>{
      'q': q,
      'limit': limit,
      'offset': offset,
    };
    if (lat != null) query['lat'] = lat;
    if (lng != null) query['lng'] = lng;
    if (sort != null) query['sort'] = sort;

    return await _apiClient.get<SearchResultModel>(
      '/api/v1/search',
      queryParameters: query,
      fromJson: (json) => SearchResultModel.fromJson(json['data'] ?? {}),
      requiresAuth: false,
    );
  }
}
