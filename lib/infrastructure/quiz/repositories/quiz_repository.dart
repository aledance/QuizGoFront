import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/i_quiz_repository.dart';
import 'package:flutter_application_1/infrastructure/quiz/data_sources/quiz_remote_data_source.dart';

class QuizRepository implements IQuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepository({required this.remoteDataSource});

  @override
  Future<Either<Exception, Quiz>> createQuiz(Quiz quiz) async {
    try {
      final createdQuiz = await remoteDataSource.createQuiz(quiz);
      return Right(createdQuiz);
    } catch (e) {
      return Left(Exception('Failed to create quiz'));
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteQuiz(String quizId) async {
    try {
      await remoteDataSource.deleteQuiz(quizId);
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to delete quiz'));
    }
  }

  @override
  Future<Either<Exception, Quiz>> getQuiz(String quizId) async {
    try {
      final quiz = await remoteDataSource.getQuiz(quizId);
      return Right(quiz);
    } catch (e) {
      return Left(Exception('Failed to get quiz'));
    }
  }

  @override
  Future<Either<Exception, List<Quiz>>> getUserQuizzes(String userId) async {
    try {
      final quizzes = await remoteDataSource.getUserQuizzes(userId);
      return Right(quizzes);
    } catch (e) {
      return Left(Exception('Failed to get user quizzes'));
    }
  }

  @override
  Future<Either<Exception, Quiz>> updateQuiz(String quizId, Quiz quiz) async {
    try {
      final updatedQuiz = await remoteDataSource.updateQuiz(quizId, quiz);
      return Right(updatedQuiz);
    } catch (e) {
      return Left(Exception('Failed to update quiz'));
    }
  }
}
