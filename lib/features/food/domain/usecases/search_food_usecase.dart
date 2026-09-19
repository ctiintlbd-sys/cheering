import '../../../../core/services/active_location_service.dart';
import '../repositories/i_food_repository.dart';
import '../entities/search_result_entity.dart';
import '../entities/search_food_params.dart';

class SearchFoodUseCase {
  final IFoodRepository _repository;
  final ActiveLocationService _locationService;

  SearchFoodUseCase(this._repository, this._locationService);

  Future<SearchResultEntity> call(SearchFoodParams params) {
    final activeAddress = _locationService.activeAddress;

    final finalParams = params.copyWith(
      lat: params.lat ?? activeAddress?.latitude,
      lng: params.lng ?? activeAddress?.longitude,
    );

    return _repository.search(finalParams);
  }
}
