import 'package:cheering/core/cache/hive_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/storage/token_storage.dart';
import 'core/storage/theme_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize();
  await TokenStorage.init();
  await HiveCacheService.init();
  await ThemeStorage.init();
  await setupServiceLocator();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const App());
}
