import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeStorage {
  static const _boxName = 'theme_settings';
  static const _keyThemeMode = 'theme_mode';

  static Box<String>? _box;

  static Future<void> init() async {
    // Hive.initFlutter() is already called in HiveCacheService.init(),
    // but calling it again is safe.
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    await _box?.put(_keyThemeMode, mode.name);
  }

  static ThemeMode getThemeMode() {
    final modeString = _box?.get(_keyThemeMode);
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
