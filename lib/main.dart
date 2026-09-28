import 'package:cheering/core/cache/hive_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/storage/token_storage.dart';
import 'core/storage/theme_storage.dart';
import 'core/storage/biometric_device_storage.dart';
import 'core/storage/biometric_storage.dart';
import 'core/storage/locale_storage.dart';
import 'core/storage/onboarding_storage.dart';
import 'core/storage/recent_search_storage.dart';
import 'features/authentication/data/services/biometric_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize();
  await TokenStorage.init();
  await BiometricStorage.init();
  await BiometricDeviceStorage.init();
  await HiveCacheService.init();
  await ThemeStorage.init();
  await LocaleStorage.init();
  await OnboardingStorage.init();
  await RecentSearchStorage.init();
  await setupServiceLocator();
  await getIt<BiometricService>().loadUiKind();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const App());
}
