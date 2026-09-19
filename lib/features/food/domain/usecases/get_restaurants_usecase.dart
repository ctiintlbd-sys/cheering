import '../../../../core/services/active_location_service.dart';
import '../repositories/i_food_repository.dart';
import '../entities/restaurant_entity.dart';
import '../entities/restaurant_query_params.dart';

class GetRestaurantsUseCase {
  final IFoodRepository _repository;
  final ActiveLocationService _locationService;

  GetRestaurantsUseCase(this._repository, this._locationService);

  Stream<List<RestaurantEntity>> call(RestaurantQueryParams params) {
    final activeAddress = _locationService.activeAddress;

    // Inject active location if not provided
    final finalParams = params.copyWith(
      lat: params.lat ?? activeAddress?.latitude,
      lng: params.lng ?? activeAddress?.longitude,
    );

    return _repository.getRestaurants(finalParams);
  }
}
