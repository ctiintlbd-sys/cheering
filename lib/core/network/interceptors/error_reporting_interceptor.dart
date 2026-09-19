import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorReportingInterceptor extends Interceptor {
  final void Function(String endpoint, int? statusCode, String? message)?
  onServerError;
  final void Function(String endpoint, DioException error)? onAnyError;
  final bool enableInDebug;

  ErrorReportingInterceptor({
    this.onServerError,
    this.onAnyError,
    this.enableInDebug = false,
  }) {
    assert(
      kDebugMode || onServerError != null || onAnyError != null,
      '[ErrorReportingInterceptor] Running in release mode without crash reporter.',
    );
  }

  bool get _isActive => enableInDebug || !kDebugMode;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isActive) {
      final endpoint = err.requestOptions.path;
      final statusCode = err.response?.statusCode;

      if (statusCode != null && statusCode >= 500) {
        final message = _extractMessage(err.response?.data) ?? err.message;
        onServerError?.call(endpoint, statusCode, message);
      }

      onAnyError?.call(endpoint, err);
    }
    handler.next(err);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['msg']?.toString();
    }
    return null;
  }
}
