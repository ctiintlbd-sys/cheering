import '../../../../core/services/active_location_service.dart';
import '../entities/search_params.dart';
import '../entities/search_result_entity.dart';
import '../repositories/i_search_repository.dart';

class GetSearchResultsUseCase {
  final ISearchRepository _repository;
  final ActiveLocationService _locationService;

  GetSearchResultsUseCase(this._repository, this._locationService);

  Future<SearchResultEntity> call(SearchParams params) {
    final activeAddress = _locationService.activeAddress;

    final finalParams = params.copyWith(
      lat: params.lat ?? activeAddress?.latitude,
      lng: params.lng ?? activeAddress?.longitude,
    );

    return _repository.search(finalParams);
  }
}
