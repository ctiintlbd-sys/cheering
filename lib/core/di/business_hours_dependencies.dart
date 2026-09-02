import 'package:get_it/get_it.dart';
import '../../features/business_hours/data/datasources/business_hours_remote_source.dart';
import '../../features/business_hours/data/repositories/business_hours_repository_impl.dart';
import '../../features/business_hours/domain/repositories/i_business_hours_repository.dart';
import '../../features/business_hours/domain/usecases/business_hours_usecases.dart';
import '../../features/business_hours/presentation/bloc/business_hours_bloc.dart';

void setupBusinessHoursDependencies(GetIt getIt) {
  // Remote Source
  getIt.registerLazySingleton(() => BusinessHoursRemoteSource(getIt()));

  // Repository
  getIt.registerLazySingleton<IBusinessHoursRepository>(
    () => BusinessHoursRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => GetBusinessHoursUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateBusinessHoursUseCase(getIt()));

  // Bloc
  getIt.registerFactory(
    () => BusinessHoursBloc(
      getBusinessHours: getIt(),
      updateBusinessHours: getIt(),
    ),
  );
}
