import 'package:get_it/get_it.dart';

import '../network/i_api_client.dart';
import '../../features/authentication/data/datasources/auth_remote_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/i_auth_repository.dart';
import '../../features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/reset_password_usecase.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';

void setupAuthDependencies(GetIt getIt) {
  getIt.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSource(getIt<IApiClient>()),
  );

  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteSource>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<IAuthRepository>()),
  );

}
