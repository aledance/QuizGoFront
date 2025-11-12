import 'package:flutter_application_1/domain/quiz/entities/option.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/question_statement.dart';

class Question {
  final UniqueId id;
  final QuestionStatement statement;
  final List<Option> options;
  final Option correctOption;

  Question({
    required this.id,
    required this.statement,
    required this.options,
    required this.correctOption,
  });
}