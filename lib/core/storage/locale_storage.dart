import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleStorage {
  static const _boxName = 'locale_settings';
  static const _keyLocale = 'locale_code';

  static Box<String>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  static Future<void> saveLocale(Locale locale) async {
    await _box?.put(_keyLocale, locale.languageCode);
  }

  static Locale getLocale() {
    final code = _box?.get(_keyLocale) ?? 'en';
    return Locale(code);
  }
}
