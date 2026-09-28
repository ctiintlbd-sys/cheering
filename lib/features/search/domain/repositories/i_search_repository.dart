import '../entities/search_params.dart';
import '../entities/search_result_entity.dart';

abstract class ISearchRepository {
  Future<SearchResultEntity> search(SearchParams params);
}
