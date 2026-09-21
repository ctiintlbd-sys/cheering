import 'package:get_it/get_it.dart';

import '../../features/cart/data/datasources/cart_remote_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/i_cart_repository.dart';
import '../../features/cart/domain/usecases/add_cart_item_usecase.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/get_checkout_summary_usecase.dart';
import '../network/i_api_client.dart';
import '../cache/cache_service.dart';

void setupCartDependencies(GetIt getIt) {
  // Data sources
  getIt.registerLazySingleton<CartRemoteSource>(
    () => CartRemoteSource(getIt<IApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ICartRepository>(
    () => CartRepositoryImpl(getIt<CartRemoteSource>(), getIt<CacheService>()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetCartUseCase(getIt<ICartRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddCartItemUseCase(getIt<ICartRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCheckoutSummaryUseCase(getIt<ICartRepository>()),
  );
}
