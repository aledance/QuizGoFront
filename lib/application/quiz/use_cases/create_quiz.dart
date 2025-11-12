import 'package:fpdart/fpdart.dart';
import 'package:flutter_application_1/domain/quiz/entities/author.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_repository.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_description.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_name.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/visibility.dart';

class CreateQuiz {
  final QuizRepository _quizRepository;

  CreateQuiz(this._quizRepository);

  Future<Either<QuizFailure, Quiz>> call({
    required String name,
    required String description,
    required Visibility visibility,
    required Author author,
  }) async {
    final newQuiz = Quiz(
      id: UniqueId(),
      name: QuizName(name),
      description: QuizDescription(description),
      visibility: visibility,
      author: author,
      createdAt: DateTime.now(),
      questions: [],
    );

    return _quizRepository.create(newQuiz);
  }
}
