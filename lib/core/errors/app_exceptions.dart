/// Base exception for app-level errors.
abstract class AppException implements Exception {
  const AppException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Thrown when API request fails (network, timeout, server error).
class ApiException extends AppException {
  const ApiException(
    super.message, {
    super.statusCode,
    this.code,
  });

  final String? code;

  factory ApiException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const ApiException('Invalid request.', statusCode: 400);
      case 401:
        return const ApiException('Session expired. Please login again.', statusCode: 401);
      case 403:
        return const ApiException('You do not have permission for this action.', statusCode: 403);
      case 404:
        return const ApiException('Resource not found.', statusCode: 404);
      case 422:
        return const ApiException('Validation failed.', statusCode: 422);
      case 500:
        return const ApiException('Server error. Please try again later.', statusCode: 500);
      default:
        return ApiException('Request failed.', statusCode: statusCode);
    }
  }
}

/// Thrown when network is unavailable.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

/// Thrown when validation fails (e.g. form fields).
class ValidationException extends AppException {
  const ValidationException(super.message, [Map<String, String>? this.fields]);

  final Map<String, String>? fields;
}

/// Thrown when auth fails (invalid credentials, expired token).
class AuthException extends AppException {
  const AuthException(super.message, [super.statusCode]);
}

/// Thrown when secure storage fails.
class StorageException extends AppException {
  const StorageException(super.message);
}
