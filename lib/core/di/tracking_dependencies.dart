import 'package:get_it/get_it.dart';

import '../../features/tracking/data/datasources/tracking_remote_source.dart';
import '../../features/tracking/data/repositories/tracking_repository_impl.dart';
import '../../features/tracking/domain/repositories/i_tracking_repository.dart';
import '../../features/tracking/domain/usecases/get_order_tracking_usecase.dart';
import '../../features/tracking/presentation/blocs/order_tracking/order_tracking_bloc.dart';
import '../network/i_api_client.dart';

void setupTrackingDependencies(GetIt getIt) {
  getIt.registerLazySingleton<TrackingRemoteSource>(
    () => TrackingRemoteSource(getIt<IApiClient>()),
  );
  getIt.registerLazySingleton<ITrackingRepository>(
    () => TrackingRepositoryImpl(getIt<TrackingRemoteSource>()),
  );
  getIt.registerLazySingleton(
    () => GetOrderTrackingUseCase(getIt<ITrackingRepository>()),
  );
  getIt.registerFactory(
    () => OrderTrackingBloc(getIt<GetOrderTrackingUseCase>()),
  );
}
