import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/i_quiz_repository.dart';

class GetUserQuizzes {
  final IQuizRepository repository;

  GetUserQuizzes(this.repository);

  Future<Either<Exception, List<Quiz>>> call(String userId) async {
    return await repository.getUserQuizzes(userId);
  }
}
