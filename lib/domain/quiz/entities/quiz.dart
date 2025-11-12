import 'package:flutter_application_1/domain/quiz/entities/question.dart';
import 'package:flutter_application_1/domain/quiz/valueobjects/quizId.dart';

class Quiz {
  final QuizId  id;
  final String title;
  final String description;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });
}