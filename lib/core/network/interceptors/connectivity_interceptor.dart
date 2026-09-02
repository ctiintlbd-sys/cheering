import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../errors/app_exception.dart';

class ConnectivityInterceptor extends Interceptor {
  final InternetConnection _checker;

  ConnectivityInterceptor({InternetConnection? checker})
      : _checker = checker ?? InternetConnection();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final hasConnection = await _checker.hasInternetAccess;
    if (!hasConnection) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const NetworkException('No internet access detected before request.'),
          message: 'No internet connection. Please check your network and try again.',
        ),
      );
    }
    handler.next(options);
  }
}