import '../entities/home_feed_entity.dart';
import '../entities/restaurant_entity.dart';
import '../entities/menu_entity.dart';
import '../entities/category_entity.dart';
import '../entities/search_result_entity.dart';
import '../entities/restaurant_query_params.dart';
import '../entities/search_food_params.dart';

abstract class IFoodRepository {
  Stream<HomeFeedEntity> getHomeFeed({double? lat, double? lng});

  Stream<List<RestaurantEntity>> getRestaurants(RestaurantQueryParams params);

  Future<RestaurantEntity> getRestaurantDetails(
    String restaurantId, {
    double? lat,
    double? lng,
  });

  Future<List<MenuCategoryEntity>> getRestaurantMenu(String restaurantId);

  Stream<List<CategoryEntity>> getCategories();

  Future<SearchResultEntity> search(SearchFoodParams params);
}
