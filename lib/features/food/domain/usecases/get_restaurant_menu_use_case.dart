import '../../../../core/network/api_result.dart';
import '../repositories/i_food_repository.dart';
import '../entities/menu_entity.dart';

class GetRestaurantMenuUseCase {
  final IFoodRepository _repository;

  GetRestaurantMenuUseCase(this._repository);

  Future<ApiResult<List<MenuCategoryEntity>>> call(String restaurantId) {
    return _repository.getRestaurantMenu(restaurantId);
  }
}
