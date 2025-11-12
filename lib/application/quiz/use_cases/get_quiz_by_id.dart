import 'package:fpdart/fpdart.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_repository.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';

class GetQuizById {
  final QuizRepository _quizRepository;

  GetQuizById(this._quizRepository);

  Future<Either<QuizFailure, Quiz>> call(String id) async {
    final quizId = UniqueId.fromUniqueString(id);
    return _quizRepository.getById(quizId);
  }
}
