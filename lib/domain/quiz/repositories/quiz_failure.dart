/// Simple replacement for Freezed union used for failures.
class QuizFailure {
  final String _type;

  const QuizFailure._(this._type);

  /// Failure when a resource is not found (404)
  factory QuizFailure.notFound() => const QuizFailure._('notFound');

  /// Generic server error
  factory QuizFailure.serverError() => const QuizFailure._('serverError');

  bool get isNotFound => _type == 'notFound';
  bool get isServerError => _type == 'serverError';

  @override
  String toString() => 'QuizFailure($_type)';
}
