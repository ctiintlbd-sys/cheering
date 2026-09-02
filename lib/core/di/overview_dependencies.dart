import 'package:get_it/get_it.dart';
import '../../features/overview/data/datasources/overview_remote_source.dart';
import '../../features/overview/data/repositories/overview_repository_impl.dart';
import '../../features/overview/domain/repositories/i_overview_repository.dart';
import '../../features/overview/domain/usecases/overview_usecases.dart';
import '../../features/overview/presentation/bloc/overview_bloc.dart';

void setupOverviewDependencies(GetIt getIt) {
  getIt.registerLazySingleton(() => OverviewRemoteSource(getIt()));

  getIt.registerLazySingleton<IOverviewRepository>(
    () => OverviewRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton(() => GetOverviewUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPerformanceUseCase(getIt()));
  getIt.registerLazySingleton(() => GetReportUseCase(getIt()));

  getIt.registerFactory(() => OverviewBloc(
        getOverview: getIt(),
        getPerformance: getIt(),
        getReport: getIt(),
      ));
}
