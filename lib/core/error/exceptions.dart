/// Custom exceptions for domain-specific errors
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message';
}

/// Thrown when validation fails
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  ValidationException(super.message, {this.fieldErrors = const {}});
}

/// Thrown when network operations fail
class NetworkException extends AppException {
  NetworkException([super.message = 'Network error occurred']);
}

/// Thrown when user is not authorized
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Unauthorized access']);
}

/// Thrown when requested resource is not found
class NotFoundException extends AppException {
  NotFoundException([super.message = 'Resource not found']);
}

/// Thrown when server returns an error
class ServerException extends AppException {
  final int? statusCode;

  ServerException(super.message, {this.statusCode});
}

/// Thrown when cache operations fail
class CacheException extends AppException {
  CacheException([super.message = 'Cache operation failed']);
}
