import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';

abstract class IQuizRepository {
  Future<Either<Exception, Quiz>> createQuiz(Quiz quiz);
  Future<Either<Exception, Quiz>> updateQuiz(String quizId, Quiz quiz);
  Future<Either<Exception, Quiz>> getQuiz(String quizId);
  Future<Either<Exception, List<Quiz>>> getUserQuizzes(String userId);
  Future<Either<Exception, Unit>> deleteQuiz(String quizId);
}
