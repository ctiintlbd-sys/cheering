sealed class AppException implements Exception {
  final String message;
  final String? details;
  final int? statusCode;

  const AppException(this.message, {this.details, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String? details])
    : super(
        'No internet connection. Please check your network and try again.',
        details: details,
      );
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Session expired. Please log in again.',
    String? details,
  ]) : super(details: details, statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message =
        'Access denied. You do not have permission to view this resource.',
    String? details,
  ]) : super(details: details, statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'Requested resource not found.',
    String? details,
  ]) : super(details: details, statusCode: 404);
}

class ConflictException extends AppException {
  const ConflictException([
    super.message = 'A data conflict occurred.',
    String? details,
  ]) : super(details: details, statusCode: 409);
}

class BadRequestException extends AppException {
  const BadRequestException(super.message, [String? details])
    : super(details: details, statusCode: 400);
}

/// Note: [ValidationException] cannot be `const` because it dynamically evaluates
/// `errors.first` from a runtime `List<String>`.
class ValidationException extends AppException {
  final List<String> errors;

  ValidationException(this.errors, [String? details])
    : super(
        errors.isNotEmpty ? errors.first : 'Validation failed.',
        details: details,
        statusCode: 422,
      );
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException([String? details])
    : super(
        'Too many requests. Please slow down and try again later.',
        details: details,
        statusCode: 429,
      );
}

class ServerException extends AppException {
  const ServerException(super.message, [int? statusCode, String? details])
    : super(details: details, statusCode: statusCode);
}

class TimeoutException extends AppException {
  const TimeoutException([String? details])
    : super('Connection timed out. Please try again.', details: details);
}

class CancelledException extends AppException {
  const CancelledException([String? details])
    : super('Request was cancelled.', details: details);
}

class SSLException extends AppException {
  const SSLException([String? details])
    : super('Security/SSL certificate validation failed.', details: details);
}

class UnknownException extends AppException {
  const UnknownException([String? details])
    : super('An unexpected error occurred.', details: details);
}
