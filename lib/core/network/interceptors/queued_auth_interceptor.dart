import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../errors/app_exception.dart';

class QueuedAuthInterceptor extends QueuedInterceptor {
  final Dio mainDio;
  final String? Function() getAccessToken;
  final String? Function() getRefreshToken;
  final Future<void> Function(String newAccessToken, String newRefreshToken) onTokenRefreshed;
  final Future<void> Function() onLogout;
  final String refreshEndpoint;

  late final Dio _tokenDio;

  QueuedAuthInterceptor({
    required this.mainDio,
    required this.getAccessToken,
    required this.getRefreshToken,
    required this.onTokenRefreshed,
    required this.onLogout,
    required this.refreshEndpoint,
  }) {
    _tokenDio = Dio(
      BaseOptions(
        baseUrl: mainDio.options.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requiresAuth = options.extra['requiresAuth'] ?? true;
    if (requiresAuth) {
      final token = getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  Future<String>? _refreshFuture;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final requiresAuth = err.requestOptions.extra['requiresAuth'] ?? true;

    if (isUnauthorized && requiresAuth) {
      final currentToken = getAccessToken();
      final requestAuthHeader = err.requestOptions.headers['Authorization'] as String?;

      // Avoid duplicate refresh calls if another request has refreshed the token already
      if (currentToken != null && requestAuthHeader != 'Bearer $currentToken') {
        return _retryRequest(err.requestOptions, currentToken, handler, err);
      }

      final refreshToken = getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await onLogout();
        return handler.reject(_unauthorizedError(err));
      }

      try {
        // Wait for any ongoing refresh, or start a new one
        final newAccess = await (_refreshFuture ??= _performRefresh(refreshToken)
            .whenComplete(() => _refreshFuture = null));

        return _retryRequest(err.requestOptions, newAccess, handler, err);
      } catch (e, st) {
        assert(() {
          debugPrint('[QueuedAuthInterceptor] Token refresh failed: $e\n$st');
          return true;
        }());
        await onLogout();
        return handler.reject(_unauthorizedError(err));
      }
    }

    handler.next(err);
  }

  Future<String> _performRefresh(String refreshToken) async {
    final response = await _tokenDio.post(
      refreshEndpoint,
      data: {'refresh_token': refreshToken},
    );

    final data = response.data['data'] as Map<String, dynamic>?;
    final tokens = data?['tokens'] as Map<String, dynamic>?;
    final newAccess = tokens?['access_token']?.toString();
    final newRefresh = tokens?['refresh_token']?.toString() ?? refreshToken;

    if (newAccess == null || newAccess.isEmpty) {
      throw Exception('Missing access token in refresh response');
    }

    await onTokenRefreshed(newAccess, newRefresh);
    return newAccess;
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
    ErrorInterceptorHandler handler,
    DioException originalErr,
  ) async {
    final retryOptions = requestOptions..headers['Authorization'] = 'Bearer $accessToken';
    try {
      final clonedResponse = await mainDio.fetch(retryOptions);
      return handler.resolve(clonedResponse);
    } catch (e, st) {
      assert(() {
        debugPrint('[QueuedAuthInterceptor] Retry with refreshed token failed: $e\n$st');
        return true;
      }());
      return handler.reject(originalErr);
    }
  }

  DioException _unauthorizedError(DioException original) {
    return DioException(
      requestOptions: original.requestOptions,
      response: original.response,
      type: DioExceptionType.badResponse,
      error: const UnauthorizedException(),
      message: 'Session expired. Please log in again.',
    );
  }
}