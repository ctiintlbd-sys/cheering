import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../../../food/data/models/restaurant_model.dart';
import '../models/favorite_toggle_model.dart';

class FavoritesRemoteSource {
  final IApiClient _apiClient;

  FavoritesRemoteSource(this._apiClient);

  Future<ApiResult<List<RestaurantModel>>> getFavorites() async {
    return _apiClient.get<List<RestaurantModel>>(
      ApiEndpoints.favorites,
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      requiresAuth: true,
    );
  }

  Future<ApiResult<FavoriteToggleModel>> toggleFavorite(
    String restaurantId,
  ) async {
    return _apiClient.post<FavoriteToggleModel>(
      ApiEndpoints.toggleFavorite(restaurantId),
      fromJson: (json) {
        final data = json['data'] as Map<String, dynamic>? ?? {};
        return FavoriteToggleModel.fromJson(data);
      },
      requiresAuth: true,
    );
  }
}
