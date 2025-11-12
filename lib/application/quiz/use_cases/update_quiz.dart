import 'package:fpdart/fpdart.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_repository.dart';

class UpdateQuiz {
  final QuizRepository _quizRepository;

  UpdateQuiz(this._quizRepository);

  Future<Either<QuizFailure, Quiz>> call(Quiz quiz) async {
    return _quizRepository.update(quiz);
  }
}
