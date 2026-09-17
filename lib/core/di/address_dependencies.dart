import 'package:get_it/get_it.dart';

import '../../features/address/data/datasources/address_remote_source.dart';
import '../../features/address/data/repositories/address_repository_impl.dart';
import '../../features/address/domain/repositories/i_address_repository.dart';
import '../../features/address/domain/usecases/create_address_usecase.dart';
import '../../features/address/domain/usecases/delete_address_usecase.dart';
import '../../features/address/domain/usecases/get_addresses_usecase.dart';
import '../../features/address/domain/usecases/set_default_address_usecase.dart';
import '../../features/address/domain/usecases/update_address_usecase.dart';
import '../../features/address/presentation/bloc/address_bloc.dart';
import '../cache/cache_service.dart';
import '../network/i_api_client.dart';

void setupAddressDependencies(GetIt getIt) {
  getIt.registerLazySingleton<AddressRemoteSource>(
    () => AddressRemoteSource(getIt<IApiClient>()),
  );

  getIt.registerLazySingleton<IAddressRepository>(
    () => AddressRepositoryImpl(
      getIt<AddressRemoteSource>(),
      getIt<CacheService>(),
    ),
  );

  getIt.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(getIt<IAddressRepository>()),
  );
  getIt.registerLazySingleton<CreateAddressUseCase>(
    () => CreateAddressUseCase(getIt<IAddressRepository>()),
  );
  getIt.registerLazySingleton<UpdateAddressUseCase>(
    () => UpdateAddressUseCase(getIt<IAddressRepository>()),
  );
  getIt.registerLazySingleton<DeleteAddressUseCase>(
    () => DeleteAddressUseCase(getIt<IAddressRepository>()),
  );
  getIt.registerLazySingleton<SetDefaultAddressUseCase>(
    () => SetDefaultAddressUseCase(getIt<IAddressRepository>()),
  );

  getIt.registerFactory<AddressBloc>(
    () => AddressBloc(
      getAddressesUseCase: getIt<GetAddressesUseCase>(),
      createAddressUseCase: getIt<CreateAddressUseCase>(),
      updateAddressUseCase: getIt<UpdateAddressUseCase>(),
      deleteAddressUseCase: getIt<DeleteAddressUseCase>(),
      setDefaultAddressUseCase: getIt<SetDefaultAddressUseCase>(),
    ),
  );
}
