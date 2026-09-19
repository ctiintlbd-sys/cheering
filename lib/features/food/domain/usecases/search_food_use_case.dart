import '../../../../core/network/api_result.dart';
import '../../../../core/services/active_location_service.dart';
import '../repositories/i_food_repository.dart';
import '../entities/search_result_entity.dart';

class SearchFoodParams {
  final String q;
  final double? lat;
  final double? lng;
  final int limit;
  final int offset;
  final String? sort;

  SearchFoodParams({
    required this.q,
    this.lat,
    this.lng,
    this.limit = 20,
    this.offset = 0,
    this.sort,
  });
}

class SearchFoodUseCase {
  final IFoodRepository _repository;
  final ActiveLocationService _locationService;

  SearchFoodUseCase(this._repository, this._locationService);

  Future<ApiResult<SearchResultEntity>> call(SearchFoodParams params) {
    final activeAddress = _locationService.activeAddress;
    return _repository.search(
      q: params.q,
      lat: params.lat ?? activeAddress?.latitude,
      lng: params.lng ?? activeAddress?.longitude,
      limit: params.limit,
      offset: params.offset,
      sort: params.sort,
    );
  }
}
