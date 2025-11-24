class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized']) : super(message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException([String message = 'Forbidden']) : super(message, statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = 'Not Found']) : super(message, statusCode: 404);
}
