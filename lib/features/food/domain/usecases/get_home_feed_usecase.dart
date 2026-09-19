import '../../../../core/services/active_location_service.dart';
import '../repositories/i_food_repository.dart';
import '../entities/home_feed_entity.dart';

class GetHomeFeedUseCase {
  final IFoodRepository _repository;
  final ActiveLocationService _locationService;

  GetHomeFeedUseCase(this._repository, this._locationService);

  Stream<HomeFeedEntity> call({double? lat, double? lng}) {
    final activeAddress = _locationService.activeAddress;
    return _repository.getHomeFeed(
      lat: lat ?? activeAddress?.latitude,
      lng: lng ?? activeAddress?.longitude,
    );
  }
}
