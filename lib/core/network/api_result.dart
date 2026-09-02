import '../errors/app_exception.dart';

sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  AppException? get errorOrNull => this is Failure<T> ? (this as Failure<T>).exception : null;
}

final class Success<T> extends ApiResult<T> {
  final T data;
  final int statusCode;
  final String? message;

  const Success(this.data, {required this.statusCode, this.message});
}

final class Failure<T> extends ApiResult<T> {
  final AppException exception;

  const Failure(this.exception);
}

// ─── Functional Extensions ───────────────────────────────────────────────────

extension ApiResultX<T> on ApiResult<T> {
  R when<R>({
    required R Function(T data, int statusCode) success,
    required R Function(AppException exception) failure,
  }) {
    return switch (this) {
      Success<T>(:final data, :final statusCode) => success(data, statusCode),
      Failure<T>(:final exception) => failure(exception),
    };
  }

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException exception) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Failure<T>(:final exception) => onFailure(exception),
    };
  }

  ApiResult<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data, :final statusCode, :final message) =>
          Success(transform(data), statusCode: statusCode, message: message),
      Failure<T>(:final exception) => Failure(exception),
    };
  }

  ApiResult<T> onSuccess(void Function(T data) action) {
    if (this is Success<T>) action((this as Success<T>).data);
    return this;
  }

  ApiResult<T> onFailure(void Function(AppException exception) action) {
    if (this is Failure<T>) action((this as Failure<T>).exception);
    return this;
  }
}