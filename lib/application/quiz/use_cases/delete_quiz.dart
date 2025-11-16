import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/i_quiz_repository.dart';

class DeleteQuiz {
  final IQuizRepository repository;

  DeleteQuiz(this.repository);

  Future<Either<Exception, Unit>> call(String quizId) async {
    return await repository.deleteQuiz(quizId);
  }
}
