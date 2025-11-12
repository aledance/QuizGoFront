import 'package:flutter_application_1/domain/quiz/entities/question.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_name.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_description.dart';

class Quiz {
  final UniqueId id;
  final QuizName name;
  final QuizDescription description;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
  });
}