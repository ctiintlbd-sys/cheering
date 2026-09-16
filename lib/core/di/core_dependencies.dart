import 'package:cheering/core/cache/cache_service.dart';
import 'package:cheering/core/cache/hive_cache_service.dart';
import 'package:cheering/core/theme/theme_cubit.dart';
import 'package:cheering/core/l10n/locale_cubit.dart';
import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../network/dio_api_client.dart';
import '../network/i_api_client.dart';
import '../router/app_router_notifier.dart';
import '../session/user_session_cleanup.dart';
import '../storage/token_storage.dart';

void setupCoreDependencies(GetIt getIt) {
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  getIt.registerLazySingleton<AppRouterNotifier>(() => AppRouterNotifier());
  getIt.registerLazySingleton<CacheService>(() => HiveCacheService.instance);
  getIt.registerLazySingleton<UserSessionCleanup>(
    () => UserSessionCleanup(getIt<CacheService>()),
  );
  getIt.registerLazySingleton<IApiClient>(
    () => DioApiClient(
      baseUrl: AppConfig.instance.baseUrl,
      getAccessToken: () => TokenStorage.accessToken,
      getRefreshToken: () => TokenStorage.refreshToken,
      onTokenRefreshed: (newAccess, newRefresh) async {
        await TokenStorage.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
      },
      onLogout: () async {
        await getIt<UserSessionCleanup>()();
        getIt<AppRouterNotifier>().updateAuth(isAuthenticated: false);
      },
    ),
  );
}
