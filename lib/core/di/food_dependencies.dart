import 'package:get_it/get_it.dart';
import '../../features/food/data/datasources/food_remote_source.dart';
import '../../features/food/data/repositories/food_repository_impl.dart';
import '../../features/food/domain/repositories/i_food_repository.dart';
import '../../features/food/domain/usecases/get_categories_usecase.dart';
import '../../features/food/domain/usecases/get_home_feed_usecase.dart';
import '../../features/food/domain/usecases/get_restaurant_details_usecase.dart';
import '../../features/food/domain/usecases/get_restaurant_menu_usecase.dart';
import '../../features/food/domain/usecases/get_restaurants_usecase.dart';
import '../network/i_api_client.dart';
import '../services/active_location_service.dart';
import '../cache/cache_service.dart';

// Blocs
import '../../features/food/presentation/blocs/home_feed/home_feed_bloc.dart';
import '../../features/food/presentation/blocs/restaurant_list/restaurant_list_bloc.dart';
import '../../features/food/presentation/blocs/restaurant_details/restaurant_details_bloc.dart';

void setupFoodDependencies(GetIt getIt) {
  // Data sources
  getIt.registerLazySingleton<FoodRemoteSource>(
    () => FoodRemoteSource(getIt<IApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<IFoodRepository>(
    () => FoodRepositoryImpl(getIt<FoodRemoteSource>(), getIt<CacheService>()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetHomeFeedUseCase(
      getIt<IFoodRepository>(),
      getIt<ActiveLocationService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetRestaurantsUseCase(
      getIt<IFoodRepository>(),
      getIt<ActiveLocationService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetRestaurantDetailsUseCase(
      getIt<IFoodRepository>(),
      getIt<ActiveLocationService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetRestaurantMenuUseCase(getIt<IFoodRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCategoriesUseCase(getIt<IFoodRepository>()),
  );

  // Blocs
  getIt.registerFactory(
    () => HomeFeedBloc(
      getIt<GetHomeFeedUseCase>(),
      getIt<GetCategoriesUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => RestaurantListBloc(getIt<GetRestaurantsUseCase>()),
  );
  getIt.registerFactory(
    () => RestaurantDetailsBloc(
      getIt<GetRestaurantDetailsUseCase>(),
      getIt<GetRestaurantMenuUseCase>(),
    ),
  );
}
