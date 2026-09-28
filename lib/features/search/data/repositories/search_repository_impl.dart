import '../../../../core/network/api_result.dart';
import '../../domain/entities/search_params.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/repositories/i_search_repository.dart';
import '../datasources/search_remote_source.dart';

class SearchRepositoryImpl implements ISearchRepository {
  final SearchRemoteSource _remoteSource;

  SearchRepositoryImpl(this._remoteSource);

  @override
  Future<SearchResultEntity> search(SearchParams params) async {
    final result = await _remoteSource.search(params);
    return result.fold(onSuccess: (data) => data, onFailure: (e) => throw e);
  }
}
