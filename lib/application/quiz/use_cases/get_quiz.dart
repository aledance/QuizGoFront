import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/i_quiz_repository.dart';

class GetQuiz {
  final IQuizRepository repository;

  GetQuiz(this.repository);

  Future<Either<Exception, Quiz>> call(String quizId) async {
    return await repository.getQuiz(quizId);
  }
}
