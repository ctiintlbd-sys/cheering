import 'package:get_it/get_it.dart';

import '../network/i_api_client.dart';
import '../router/app_router_notifier.dart';
import '../../features/profile/data/datasources/profile_remote_source.dart';
import '../../features/authentication/data/datasources/auth_remote_source.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/data/services/biometric_auth_service.dart';
import '../../features/authentication/data/services/biometric_key_service.dart';
import '../../features/authentication/data/services/biometric_service.dart';
import '../../features/authentication/data/services/google_auth_service.dart';
import '../../features/authentication/domain/repositories/i_auth_repository.dart';
import '../../features/authentication/domain/usecases/check_stored_session_usecase.dart';
import '../../features/authentication/domain/usecases/clear_local_session_usecase.dart';
import '../../features/authentication/domain/usecases/enable_biometrics_usecase.dart';
import '../../features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/login_with_biometrics_usecase.dart';
import '../../features/authentication/domain/usecases/login_with_google_usecase.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';
import '../../features/authentication/domain/usecases/reset_password_usecase.dart';
import '../../features/authentication/domain/usecases/send_otp_usecase.dart';
import '../../features/authentication/domain/usecases/verify_otp_usecase.dart';

void setupAuthDependencies(GetIt getIt) {
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());

  getIt.registerLazySingleton<BiometricKeyService>(() => BiometricKeyService());

  getIt.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSource(getIt<IApiClient>()),
  );

  getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());

  getIt.registerLazySingleton<BiometricAuthService>(
    () => BiometricAuthService(
      getIt<AuthRemoteSource>(),
      getIt<BiometricKeyService>(),
      getIt<BiometricService>(),
    ),
  );

  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteSource>(),
      getIt<GoogleAuthService>(),
      getIt<BiometricAuthService>(),
      getIt<ProfileRemoteSource>(),
    ),
  );

  getIt.registerLazySingleton<SendOtpUseCase>(
    () => SendOtpUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<LoginWithGoogleUseCase>(
    () => LoginWithGoogleUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<LoginWithBiometricsUseCase>(
    () => LoginWithBiometricsUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<EnableBiometricsUseCase>(
    () => EnableBiometricsUseCase(
      getIt<IAuthRepository>(),
      getIt<BiometricService>(),
    ),
  );

  getIt.registerLazySingleton<CheckStoredSessionUseCase>(
    () => CheckStoredSessionUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<ClearLocalSessionUseCase>(
    () => ClearLocalSessionUseCase(getIt<IAuthRepository>()),
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

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      sendOtpUseCase: getIt<SendOtpUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
      loginWithBiometricsUseCase: getIt<LoginWithBiometricsUseCase>(),
      enableBiometricsUseCase: getIt<EnableBiometricsUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      biometricService: getIt<BiometricService>(),
      routerNotifier: getIt<AppRouterNotifier>(),
    ),
  );
}
