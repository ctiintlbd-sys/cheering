import '../../../food/domain/entities/restaurant_entity.dart';
import '../entities/favorite_toggle_entity.dart';

abstract class IFavoritesRepository {
  Stream<List<RestaurantEntity>> getFavorites();
  Future<FavoriteToggleEntity> toggleFavorite(String restaurantId);
  Future<void> clearLocalCache();
}
