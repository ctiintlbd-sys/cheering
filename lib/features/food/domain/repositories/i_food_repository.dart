import '../../../../core/network/api_result.dart';
import '../entities/home_feed_entity.dart';
import '../entities/restaurant_entity.dart';
import '../entities/menu_entity.dart';
import '../entities/category_entity.dart';
import '../entities/search_result_entity.dart';

abstract class IFoodRepository {
  Future<ApiResult<HomeFeedEntity>> getHomeFeed({double? lat, double? lng});
  
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
  });

  Future<ApiResult<RestaurantEntity>> getRestaurantDetails(
    String restaurantId, {
    double? lat,
    double? lng,
  });

  Future<ApiResult<List<MenuCategoryEntity>>> getRestaurantMenu(String restaurantId);

  Future<ApiResult<List<CategoryEntity>>> getCategories();

  Future<ApiResult<SearchResultEntity>> search({
    required String q,
    double? lat,
    double? lng,
    int limit = 20,
    int offset = 0,
    String? sort,
  });
}
