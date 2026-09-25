import 'package:get_it/get_it.dart';

import '../../features/orders/data/datasources/orders_remote_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/i_orders_repository.dart';
import '../../features/orders/domain/usecases/cancel_order_usecase.dart';
import '../../features/orders/domain/usecases/create_order_usecase.dart';
import '../../features/orders/domain/usecases/get_order_details_usecase.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/presentation/blocs/order_details/order_details_bloc.dart';
import '../../features/orders/presentation/blocs/order_list/order_list_bloc.dart';
import '../cache/cache_service.dart';
import '../network/i_api_client.dart';

void setupOrdersDependencies(GetIt getIt) {
  // Data sources
  getIt.registerLazySingleton<OrdersRemoteSource>(
    () => OrdersRemoteSource(getIt<IApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<IOrdersRepository>(
    () => OrdersRepositoryImpl(getIt<OrdersRemoteSource>(), getIt<CacheService>()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => CreateOrderUseCase(getIt<IOrdersRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetOrdersUseCase(getIt<IOrdersRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetOrderDetailsUseCase(getIt<IOrdersRepository>()),
  );
  getIt.registerLazySingleton(
    () => CancelOrderUseCase(getIt<IOrdersRepository>()),
  );

  // Blocs
  getIt.registerFactory(
    () => OrderListBloc(getIt<GetOrdersUseCase>()),
  );
  getIt.registerFactory(
    () => OrderDetailsBloc(
      getIt<GetOrderDetailsUseCase>(),
      getIt<CancelOrderUseCase>(),
    ),
  );
}
