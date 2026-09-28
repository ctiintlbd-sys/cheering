import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../../domain/entities/search_params.dart';
import '../models/search_result_model.dart';

class SearchRemoteSource {
  final IApiClient _apiClient;

  SearchRemoteSource(this._apiClient);

  Future<ApiResult<SearchResultModel>> search(SearchParams params) {
    return _apiClient.get<SearchResultModel>(
      ApiEndpoints.search,
      queryParameters: params.toMap(),
      fromJson: (json) => SearchResultModel.fromJson(json['data'] ?? {}),
      requiresAuth: false,
    );
  }
}
