import 'package:hive_flutter/hive_flutter.dart';

class OnboardingStorage {
  OnboardingStorage._();

  static const String _boxName = 'onboarding_settings';
  static const String _keySeen = 'is_onboarding_completed';

  static Box<bool>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<bool>(_boxName);
  }

  static bool get isOnboardingCompleted =>
      _box?.get(_keySeen, defaultValue: false) ?? false;

  static Future<void> setOnboardingCompleted([bool completed = true]) async {
    await _box?.put(_keySeen, completed);
  }
}
