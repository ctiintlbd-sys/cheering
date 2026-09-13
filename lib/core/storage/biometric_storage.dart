import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyBiometricEnabled = 'is_biometric_enabled';

  static bool _cachedIsEnabled = false;

  static Future<void> init() async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    _cachedIsEnabled = value == 'true';
  }

  static bool get isBiometricEnabled => _cachedIsEnabled;

  static Future<void> setBiometricEnabled(bool enabled) async {
    _cachedIsEnabled = enabled;
    await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
  }

  static Future<void> clear() async {
    _cachedIsEnabled = false;
    await _storage.delete(key: _keyBiometricEnabled);
  }
}
