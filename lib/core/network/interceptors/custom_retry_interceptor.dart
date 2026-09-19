import 'package:dio/dio.dart';

class CustomRetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  CustomRetryInterceptor({
    required this.dio,
    this.retries = 2,
    this.retryDelays = const [Duration(seconds: 1), Duration(seconds: 2)],
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra['retryAttempt'] as int? ?? 0);

    if (_shouldRetry(err, attempt)) {
      final delay = attempt < retryDelays.length
          ? retryDelays[attempt]
          : const Duration(seconds: 1);
      await Future.delayed(delay);

      try {
        final options = err.requestOptions;
        options.extra['retryAttempt'] = attempt + 1;
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e); // Let the next interceptor (or retry) catch it
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err, int attempt) {
    if (attempt >= retries) return false;

    if (err.type == DioExceptionType.cancel) return false;
    if (err.type == DioExceptionType.badCertificate) return false;

    final method = err.requestOptions.method.toUpperCase();

    final isIdempotent = {'GET', 'HEAD', 'OPTIONS'}.contains(method);

    if (!isIdempotent) return false;

    final status = err.response?.statusCode;

    final retryableStatusCodes = {
      408, // Request Timeout
      425, // Too Early
      429, // Too Many Requests
      500, // Internal Server Error
      502, // Bad Gateway
      503, // Service Unavailable
      504, // Gateway Timeout
    };

    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (status != null && retryableStatusCodes.contains(status));
  }
}
