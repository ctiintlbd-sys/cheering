import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';

  static String? _cachedAccessToken;
  static String? _cachedRefreshToken;

  static Future<void> init() async {
    _cachedAccessToken = await _storage.read(key: _keyAccess);
    _cachedRefreshToken = await _storage.read(key: _keyRefresh);
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    await _storage.write(key: _keyAccess, value: accessToken);
    await _storage.write(key: _keyRefresh, value: refreshToken);
  }

  static String? get accessToken => _cachedAccessToken;
  static String? get refreshToken => _cachedRefreshToken;

  static Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
  }
}

