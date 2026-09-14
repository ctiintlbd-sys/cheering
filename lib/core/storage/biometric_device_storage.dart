import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Server biometric enrollment (device id + signing key). Survives logout.
class BiometricDeviceStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyDeviceId = 'biometric_device_id';
  static const _keyPrivateKeyPkcs8 = 'biometric_private_key_pkcs8';

  static String? _cachedDeviceId;
  static String? _cachedPrivateKeyPkcs8;

  static Future<void> init() async {
    _cachedDeviceId = await _storage.read(key: _keyDeviceId);
    _cachedPrivateKeyPkcs8 = await _storage.read(key: _keyPrivateKeyPkcs8);
  }

  static String? get deviceId => _cachedDeviceId;

  static String? get privateKeyPkcs8Base64 => _cachedPrivateKeyPkcs8;

  static bool get hasEnrollment =>
      deviceId != null &&
      deviceId!.isNotEmpty &&
      privateKeyPkcs8Base64 != null &&
      privateKeyPkcs8Base64!.isNotEmpty;

  static Future<void> saveEnrollment({
    required String deviceId,
    required String privateKeyPkcs8Base64,
  }) async {
    _cachedDeviceId = deviceId;
    _cachedPrivateKeyPkcs8 = privateKeyPkcs8Base64;
    await _storage.write(key: _keyDeviceId, value: deviceId);
    await _storage.write(
      key: _keyPrivateKeyPkcs8,
      value: privateKeyPkcs8Base64,
    );
  }

  static Future<void> clear() async {
    _cachedDeviceId = null;
    _cachedPrivateKeyPkcs8 = null;
    await _storage.delete(key: _keyDeviceId);
    await _storage.delete(key: _keyPrivateKeyPkcs8);
  }
}
