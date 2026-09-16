import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import '../config/api_endpoints.dart';
import '../errors/app_exception.dart';
import '../utils/mime_utils.dart';
import 'api_result.dart';
import 'i_api_client.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/custom_logger_interceptor.dart';
import 'interceptors/custom_retry_interceptor.dart';
import 'interceptors/error_reporting_interceptor.dart';
import 'interceptors/queued_auth_interceptor.dart';

class DioApiClient implements IApiClient {
  final Dio _dio;
  late final CacheOptions defaultCacheOptions;

  DioApiClient({
    required String baseUrl,
    required String? Function() getAccessToken,
    required String? Function() getRefreshToken,
    required Future<void> Function(String newAccess, String newRefresh)
    onTokenRefreshed,
    required Future<void> Function() onLogout,
    String refreshEndpoint = ApiEndpoints.refreshToken,
    Duration connectTimeout = ApiEndpoints.connectTimeout,
    Duration receiveTimeout = ApiEndpoints.receiveTimeout,
    Duration sendTimeout = ApiEndpoints.sendTimeout,
    bool isDebug = kDebugMode,
    void Function(String endpoint, int? statusCode, String? message)?
    onServerError,
    void Function(String endpoint, DioException error)? onAnyError,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           sendTimeout: sendTimeout,
           headers: {
             'Accept': 'application/json',
             'Content-Type': 'application/json',
           },
           responseType: ResponseType.json,
         ),
       ) {
    defaultCacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
    );

    _dio.interceptors.addAll([
      ConnectivityInterceptor(),
      QueuedAuthInterceptor(
        mainDio: _dio,
        getAccessToken: getAccessToken,
        getRefreshToken: getRefreshToken,
        onTokenRefreshed: onTokenRefreshed,
        onLogout: onLogout,
        refreshEndpoint: refreshEndpoint,
      ),
      DioCacheInterceptor(options: defaultCacheOptions),
      CustomRetryInterceptor(
        dio: _dio,
        retries: 2,
        retryDelays: const [Duration(seconds: 1), Duration(seconds: 2)],
      ),
      ErrorReportingInterceptor(
        onServerError: onServerError,
        onAnyError: onAnyError,
      ),
      if (isDebug) CustomLoggerInterceptor(),
    ]);
  }

  // ─── Safe Execution Engine ─────────────────────────────────────────────────

  Future<ApiResult<R>> _safeExecute<R>({
    required Future<Response> Function() request,
    required Future<R> Function(dynamic data) parse,
  }) async {
    try {
      final response = await request();
      final parsedData = await parse(response.data);
      return Success(
        parsedData,
        statusCode: response.statusCode ?? 200,
        message: _extractMessage(response.data),
      );
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  // ─── HTTP Methods ──────────────────────────────────────────────────────────

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) {
    return _safeExecute(
      request: () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(headers, requiresAuth),
        cancelToken: cancelToken,
      ),
      parse: (data) => _parseData(data, fromJson),
    );
  }

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) {
    return _safeExecute(
      request: () => _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: _buildOptions(headers, requiresAuth),
        cancelToken: cancelToken,
      ),
      parse: (data) => _parseData(data, fromJson),
    );
  }

  @override
  Future<ApiResult<T>> put<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) {
    return _safeExecute(
      request: () => _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: _buildOptions(headers, requiresAuth),
        cancelToken: cancelToken,
      ),
      parse: (data) => _parseData(data, fromJson),
    );
  }

  @override
  Future<ApiResult<T>> patch<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) {
    return _safeExecute(
      request: () => _dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: _buildOptions(headers, requiresAuth),
        cancelToken: cancelToken,
      ),
      parse: (data) => _parseData(data, fromJson),
    );
  }

  @override
  Future<ApiResult<T?>> delete<T>(
    String path, {
    T Function(dynamic json)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) {
    return _safeExecute<T?>(
      request: () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers, requiresAuth),
        cancelToken: cancelToken,
      ),
      parse: (data) async {
        if (fromJson != null && data != null && data != '') {
          return await _parseData(data, fromJson);
        }
        return null;
      },
    );
  }

  @override
  Future<ApiResult<T>> upload<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    required Map<String, dynamic> body,
    Map<String, File>? singleFiles,
    Map<String, List<File>>? multiFiles,
    bool isPatch = false,
    bool requiresAuth = true,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    return _safeExecute(
      request: () async {
        final formMap = _flattenBody(body);

        if (singleFiles != null) {
          for (final entry in singleFiles.entries) {
            formMap[entry.key] = await _toMultipart(entry.value);
          }
        }

        if (multiFiles != null) {
          for (final entry in multiFiles.entries) {
            formMap[entry.key] = await Future.wait(
              entry.value.map(_toMultipart),
            );
          }
        }

        final formData = FormData.fromMap(formMap);
        final options = Options(
          headers: {'Content-Type': 'multipart/form-data'},
          extra: {'requiresAuth': requiresAuth},
        );

        return isPatch
            ? _dio.patch(
                path,
                data: formData,
                options: options,
                onSendProgress: onSendProgress,
                cancelToken: cancelToken,
              )
            : _dio.post(
                path,
                data: formData,
                options: options,
                onSendProgress: onSendProgress,
                cancelToken: cancelToken,
              );
      },
      parse: (data) => _parseData(data, fromJson),
    );
  }

  @override
  Future<ApiResult<void>> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    void Function(int received, int total)? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    return _safeExecute<void>(
      request: () => _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: _buildOptions(null, requiresAuth),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      ),
      parse: (_) async {},
    );
  }

  @override
  Future<ApiResult<void>> putBinary(
    String url, {
    required Stream<List<int>> stream,
    required int length,
    required String contentType,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    return _safeExecute<void>(
      request: () => _dio.put(
        url,
        data: stream,
        options: Options(
          headers: {
            Headers.contentTypeHeader: contentType,
            Headers.contentLengthHeader: length,
          },
          extra: {'requiresAuth': false},
        ),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      ),
      parse: (_) async {},
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  Options _buildOptions(Map<String, dynamic>? headers, bool requiresAuth) {
    return Options(
      headers: headers ?? {},
      extra: {'requiresAuth': requiresAuth},
    );
  }

  Future<T> _parseData<T>(dynamic data, T Function(dynamic) parser) async {
    if (data is List && data.length > 100) {
      try {
        return await compute(_isolateParse<T>, _IsolatePayload(data, parser));
      } catch (_) {
        return parser(data);
      }
    }
    return parser(data);
  }

  static T _isolateParse<T>(_IsolatePayload<T> payload) {
    return payload.parser(payload.data);
  }

  Future<MultipartFile> _toMultipart(File file) async {
    final contentType = getMediaTypeForFile(file.path);
    final filename = file.path.split(RegExp(r'[/\\]')).last;
    return MultipartFile.fromFile(
      file.path,
      filename: filename,
      contentType: contentType,
    );
  }

  Map<String, dynamic> _flattenBody(
    Map<String, dynamic> body, [
    String prefix = '',
  ]) {
    final result = <String, dynamic>{};
    body.forEach((key, value) {
      if (value == null) return;
      final fullKey = prefix.isEmpty ? key : '$prefix[$key]';
      if (value is Map<String, dynamic>) {
        result.addAll(_flattenBody(value, fullKey));
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          final indexedKey = '$fullKey[$i]';
          final item = value[i];
          if (item is Map<String, dynamic>) {
            result.addAll(_flattenBody(item, indexedKey));
          } else if (item != null) {
            result[indexedKey] = item;
          }
        }
      } else {
        result[fullKey] = value;
      }
    });
    return result;
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['msg']?.toString() ??
          data['error']?.toString();
    }
    return null;
  }

  AppException _handleDioError(DioException error) {
    if (error.error is AppException) return error.error as AppException;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => TimeoutException(error.message),

      DioExceptionType.connectionError =>
        error.error is NetworkException
            ? error.error as NetworkException
            : NetworkException(error.message),

      DioExceptionType.badCertificate => SSLException(error.message),

      DioExceptionType.cancel => CancelledException(error.message),

      DioExceptionType.badResponse => _handleBadResponse(error),

      DioExceptionType.unknown =>
        (error.message?.contains('SocketException') ?? false)
            ? NetworkException(error.message)
            : UnknownException(error.message),
    };
  }

  AppException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final resData = error.response?.data;
    final message = _parseErrorMessage(resData);

    debugPrint('❌ [API ERROR BODY] $resData');
    debugPrint('❌ [API ERROR CODE] ${resData is Map ? resData['error'] : null}');
    debugPrint('❌ [API ERROR MESSAGE] $message');

    return switch (statusCode) {
      400 => BadRequestException(message, error.message),
      401 => UnauthorizedException(message, error.message),
      403 => ForbiddenException(message, error.message),
      404 => NotFoundException(message, error.message),
      409 => ConflictException(message, error.message),
      422 => ValidationException(
        _parseValidationErrors(resData),
        error.message,
      ),
      429 => TooManyRequestsException(error.message),
      500 => ServerException('Internal server error (500)', 500, error.message),
      _ => ServerException(message, statusCode, error.message),
    };
  }

  String _parseErrorMessage(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return 'An unexpected server error occurred';
    }

    // Top-level message
    if (data['message'] != null) {
      return data['message'].toString();
    }

    // Nested error.message
    final error = data['error'];

    if (error is Map<String, dynamic>) {
      if (error['message'] != null) {
        return error['message'].toString();
      }
    }

    // Existing fallback
    if (data['error'] != null) {
      return data['error'].toString();
    }

    if (data['msg'] != null) {
      return data['msg'].toString();
    }

    return 'Unexpected server response';
  }
  List<String> _parseValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] != null) {
      final errors = data['errors'];
      if (errors is List) {
        return errors.map((e) => e.toString()).toList();
      }
      if (errors is Map) {
        final List<String> parsedList = [];
        errors.forEach((key, value) {
          if (value is List) {
            parsedList.addAll(value.map((e) => e.toString()));
          } else if (value != null) {
            parsedList.add(value.toString());
          }
        });
        if (parsedList.isNotEmpty) return parsedList;
      }
    }
    return [_parseErrorMessage(data)];
  }
}

class _IsolatePayload<T> {
  final dynamic data;
  final T Function(dynamic) parser;

  const _IsolatePayload(this.data, this.parser);
}
