/// Application-level error types. These wrap infrastructure exceptions and
/// provide clearer semantics to the UI layer.
abstract class ApplicationError implements Exception {
  final String message;
  ApplicationError(this.message);
  @override
  String toString() => '$runtimeType: $message';
}

class ValidationError extends ApplicationError {
  ValidationError(String message) : super(message);
}

class AuthError extends ApplicationError {
  AuthError(String message) : super(message);
}

class NotFoundError extends ApplicationError {
  NotFoundError(String message) : super(message);
}

class ApiError extends ApplicationError {
  final int? statusCode;
  ApiError(String message, {this.statusCode}) : super(message);
}
