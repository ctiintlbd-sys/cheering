import 'dart:io';
import 'package:dio/dio.dart';
import 'api_result.dart';

abstract class IApiClient {
  Future<ApiResult<T>> get<T>(
      String path, {
        required T Function(dynamic json) fromJson,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool requiresAuth = true,
        CancelToken? cancelToken,
      });

  Future<ApiResult<T>> post<T>(
      String path, {
        required T Function(dynamic json) fromJson,
        dynamic body,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool requiresAuth = true,
        CancelToken? cancelToken,
      });

  Future<ApiResult<T>> put<T>(
      String path, {
        required T Function(dynamic json) fromJson,
        dynamic body,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool requiresAuth = true,
        CancelToken? cancelToken,
      });

  Future<ApiResult<T>> patch<T>(
      String path, {
        required T Function(dynamic json) fromJson,
        dynamic body,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool requiresAuth = true,
        CancelToken? cancelToken,
      });

  Future<ApiResult<T?>> delete<T>(
      String path, {
        T Function(dynamic json)? fromJson,
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool requiresAuth = true,
        CancelToken? cancelToken,
      });

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
      });

  Future<ApiResult<void>> download(
      String urlPath,
      String savePath, {
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
        void Function(int received, int total)? onReceiveProgress,
        CancelToken? cancelToken,
      });

  Future<ApiResult<void>> putBinary(
      String url, {
        required Stream<List<int>> stream,
        required int length,
        required String contentType,
        void Function(int sent, int total)? onSendProgress,
        CancelToken? cancelToken,
      });
}