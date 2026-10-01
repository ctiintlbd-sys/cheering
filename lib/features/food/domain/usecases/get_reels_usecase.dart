import '../../../../core/services/active_location_service.dart';
import '../entities/reel_entity.dart';
import '../entities/reel_query_params.dart';
import '../repositories/i_food_repository.dart';

class GetReelsUseCase {
  final IFoodRepository _repository;
  final ActiveLocationService _locationService;

  GetReelsUseCase(this._repository, this._locationService);

  Stream<ReelsResponseEntity> call(ReelQueryParams params) {
    final activeAddress = _locationService.activeAddress;

    // Inject active location if not provided to calculate distance & delivery fee
    final finalParams = params.copyWith(
      lat: params.lat ?? activeAddress?.latitude,
      lng: params.lng ?? activeAddress?.longitude,
    );

    return _repository.getReels(finalParams);
  }
}
