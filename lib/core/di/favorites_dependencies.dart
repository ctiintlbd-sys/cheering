import 'package:get_it/get_it.dart';
import '../../features/favorites/data/datasources/favorites_remote_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/i_favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import '../cache/cache_service.dart';
import '../network/i_api_client.dart';

void setupFavoritesDependencies(GetIt getIt) {
  // Data sources
  getIt.registerLazySingleton<FavoritesRemoteSource>(
    () => FavoritesRemoteSource(getIt<IApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<IFavoritesRepository>(
    () => FavoritesRepositoryImpl(
      getIt<FavoritesRemoteSource>(),
      getIt<CacheService>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetFavoritesUseCase(getIt<IFavoritesRepository>()),
  );
  getIt.registerLazySingleton(
    () => ToggleFavoriteUseCase(getIt<IFavoritesRepository>()),
  );
}
