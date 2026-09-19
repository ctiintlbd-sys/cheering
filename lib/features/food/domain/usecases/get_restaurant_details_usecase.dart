import '../../../../core/services/active_location_service.dart';
import '../repositories/i_food_repository.dart';
import '../entities/restaurant_entity.dart';

class GetRestaurantDetailsUseCase {
  final IFoodRepository _repository;
  final ActiveLocationService _locationService;

  GetRestaurantDetailsUseCase(this._repository, this._locationService);

  Future<RestaurantEntity> call(
    String restaurantId, {
    double? lat,
    double? lng,
  }) {
    final activeAddress = _locationService.activeAddress;
    return _repository.getRestaurantDetails(
      restaurantId,
      lat: lat ?? activeAddress?.latitude,
      lng: lng ?? activeAddress?.longitude,
    );
  }
}
