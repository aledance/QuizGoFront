import 'package:flutter_application_1/domain/quiz/entities/option.dart';
import 'package:flutter_application_1/domain/quiz/valueobjects/questionid.dart';
import 'package:flutter_application_1/domain/quiz/valueobjects/answer.dart';

class Question {
  final QuestionId id;
  final String text;
  final List<Option> options;
  final Answer correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}