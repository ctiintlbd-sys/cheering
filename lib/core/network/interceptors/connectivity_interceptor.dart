import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../errors/app_exception.dart';

class ConnectivityInterceptor extends Interceptor {
  final InternetConnection _checker;

  ConnectivityInterceptor({InternetConnection? checker})
    : _checker = checker ?? InternetConnection();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasConnection = await _checker.hasInternetAccess;
    if (!hasConnection) {
      // This blocks the request before it is ever sent, and the probe hosts are
      // third parties — so say so, otherwise it looks like the API never fired.
      debugPrint(
        '[ConnectivityInterceptor] blocked ${options.method} ${options.path} '
        '— all reachability probes failed',
      );
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const NetworkException(
            'No internet access detected before request.',
          ),
          message:
              'No internet connection. Please check your network and try again.',
        ),
      );
    }
    handler.next(options);
  }
}
