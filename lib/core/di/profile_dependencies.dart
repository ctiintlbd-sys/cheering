import 'package:get_it/get_it.dart';

import '../../features/profile/data/datasources/profile_remote_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/i_profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_profile_image_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../cache/cache_service.dart';
import '../network/i_api_client.dart';

void setupProfileDependencies(GetIt getIt) {
  // Remote Source
  getIt.registerLazySingleton<ProfileRemoteSource>(
    () => ProfileRemoteSource(getIt<IApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(
          getIt<ProfileRemoteSource>(),
          getIt<CacheService>(),
        ),
  );

  // UseCases
  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<IProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<IProfileRepository>()),
  );
  getIt.registerLazySingleton<UploadProfileImageUseCase>(
    () => UploadProfileImageUseCase(getIt<IProfileRepository>()),
  );

  // Bloc
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      uploadProfileImageUseCase: getIt<UploadProfileImageUseCase>(),
    ),
  );
}
