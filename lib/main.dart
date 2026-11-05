import 'dart:ui';
import 'package:cheering/core/cache/hive_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/services/notification_service.dart';
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

  // Protect app from unhandled async / platform errors that would crash to home screen
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled error prevented crash: $error\n$stack');
    return true;
  };

  // Optimize image memory cache to prevent Out Of Memory crashes on low/mid-range phones
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50MB max

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
  await NotificationService.init();
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
