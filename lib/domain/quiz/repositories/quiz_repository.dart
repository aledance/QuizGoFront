import 'package:fpdart/fpdart.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';

abstract class QuizRepository {
  Future<Either<QuizFailure, Quiz>> create(Quiz quiz);
  Future<Either<QuizFailure, Quiz>> update(Quiz quiz);
  Future<Either<QuizFailure, Quiz>> getById(UniqueId id);
  Future<Either<QuizFailure, List<Quiz>>> findPublishedQuizzes();
}
