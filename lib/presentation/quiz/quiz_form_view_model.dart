import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_application_1/application/quiz/use_cases/create_quiz.dart';
import 'package:flutter_application_1/domain/quiz/entities/author.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/visibility.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';

enum QuizFormState { idle, loading, success, error }

class QuizFormViewModel extends ChangeNotifier {
  final CreateQuiz _createQuiz;

  QuizFormState state = QuizFormState.idle;
  String? errorMessage;

  QuizFormViewModel(this._createQuiz);

  Future<void> createQuiz({
    required String name,
    required String description,
    required Visibility visibility,
    required Author author,
  }) async {
    state = QuizFormState.loading;
    errorMessage = null;
    notifyListeners();

    final Either<QuizFailure, dynamic> result = await _createQuiz(
      name: name,
      description: description,
      visibility: visibility,
      author: author,
    );

    result.match(
      (failure) {
        state = QuizFormState.error;
        errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (quiz) {
        state = QuizFormState.success;
        notifyListeners();
      },
    );
  }

  String _mapFailureToMessage(QuizFailure f) {
    if (f.isNotFound) {
      return 'Recurso no encontrado';
    }
    if (f.isServerError) {
      return 'Error del servidor. Intenta más tarde';
    }
    return 'Ocurrió un error';
  }
}
