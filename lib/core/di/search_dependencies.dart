import 'package:get_it/get_it.dart';

import '../../features/search/data/datasources/search_remote_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/i_search_repository.dart';
import '../../features/search/domain/usecases/get_recent_searches_usecase.dart';
import '../../features/search/domain/usecases/get_search_results_usecase.dart';
import '../../features/search/domain/usecases/save_recent_search_usecase.dart';
import '../../features/search/presentation/blocs/search/search_bloc.dart';
import '../network/i_api_client.dart';
import '../services/active_location_service.dart';

void setupSearchDependencies(GetIt getIt) {
  getIt.registerLazySingleton<SearchRemoteSource>(
    () => SearchRemoteSource(getIt<IApiClient>()),
  );

  getIt.registerLazySingleton<ISearchRepository>(
    () => SearchRepositoryImpl(getIt<SearchRemoteSource>()),
  );

  getIt.registerLazySingleton(
    () => GetSearchResultsUseCase(
      getIt<ISearchRepository>(),
      getIt<ActiveLocationService>(),
    ),
  );
  getIt.registerLazySingleton(GetRecentSearchesUseCase.new);
  getIt.registerLazySingleton(SaveRecentSearchUseCase.new);

  getIt.registerFactory(
    () => SearchBloc(
      getIt<GetSearchResultsUseCase>(),
      getIt<GetRecentSearchesUseCase>(),
      getIt<SaveRecentSearchUseCase>(),
    ),
  );
}
