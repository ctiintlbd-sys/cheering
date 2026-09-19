import '../../../../core/network/api_result.dart';
import '../../../../core/services/active_location_service.dart';
import '../repositories/i_food_repository.dart';
import '../entities/restaurant_entity.dart';

class GetRestaurantsParams {
  final double? lat;
  final double? lng;
  final int? radius;
  final String? cuisine;
  final String? category;
  final bool? isOpen;
  final String? sort;
  final int? maxDeliveryFee;
  final double? minRating;
  final String? q;
  final int limit;
  final int offset;

  GetRestaurantsParams({
    this.lat,
    this.lng,
    this.radius,
    this.cuisine,
    this.category,
    this.isOpen,
    this.sort,
    this.maxDeliveryFee,
    this.minRating,
    this.q,
    this.limit = 20,
    this.offset = 0,
  });
}

class GetRestaurantsUseCase {
  final IFoodRepository _repository;
  final ActiveLocationService _locationService;

  GetRestaurantsUseCase(this._repository, this._locationService);

  Future<ApiResult<List<RestaurantEntity>>> call(GetRestaurantsParams params) {
    final activeAddress = _locationService.activeAddress;
    return _repository.getRestaurants(
      lat: params.lat ?? activeAddress?.latitude,
      lng: params.lng ?? activeAddress?.longitude,
      radius: params.radius,
      cuisine: params.cuisine,
      category: params.category,
      isOpen: params.isOpen,
      sort: params.sort,
      maxDeliveryFee: params.maxDeliveryFee,
      minRating: params.minRating,
      q: params.q,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
