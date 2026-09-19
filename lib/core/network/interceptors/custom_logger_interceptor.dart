import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('➡️ [DIO REQ] ${options.method} => ${options.uri}');
      if (options.data != null) {
        debugPrint('   Body: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✅ [DIO RES ${response.statusCode}] ${response.requestOptions.uri}',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '❌ [DIO ERR ${err.response?.statusCode}] ${err.requestOptions.uri}',
      );
      debugPrint('   Message: ${err.message}');
    }
    super.onError(err, handler);
  }
}
