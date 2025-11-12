import 'package:fpdart/fpdart.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_repository.dart';

class FindPublishedQuizzes {
  final QuizRepository _quizRepository;

  FindPublishedQuizzes(this._quizRepository);

  Future<Either<QuizFailure, List<Quiz>>> call() async {
    return _quizRepository.findPublishedQuizzes();
  }
}
