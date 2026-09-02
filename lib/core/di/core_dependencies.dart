import 'package:cheering/core/cache/cache_service.dart';
import 'package:cheering/core/cache/hive_cache_service.dart';
import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../network/dio_api_client.dart';
import '../network/i_api_client.dart';
import '../network/request_manager.dart';
import '../router/app_router_notifier.dart';
import '../storage/token_storage.dart';

void setupCoreDependencies(GetIt getIt) {
  getIt.registerLazySingleton<AppRouterNotifier>(() => AppRouterNotifier());
  getIt.registerLazySingleton<RequestManager>(() => RequestManager());
  getIt.registerLazySingleton<CacheService>(() => HiveCacheService.instance);
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
        await TokenStorage.clearTokens();
        getIt<AppRouterNotifier>().updateAuth(isAuthenticated: false);
      },
    ),
  );
}
