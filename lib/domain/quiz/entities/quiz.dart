import 'package:flutter_application_1/domain/quiz/entities/author.dart';
import 'package:flutter_application_1/domain/quiz/entities/question.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/image_url.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/play_count.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_description.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_name.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_theme.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/visibility.dart';

class Quiz {
  final UniqueId id;
  final QuizName name;
  final QuizDescription description;
  final ImageUrl? kahootImage; // Opcional
  final Visibility visibility;
  final List<QuizTheme>? themes; // Opcional
  final Author author;
  final DateTime createdAt;
  final PlayCount? playCount; // Opcional
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.name,
    required this.description,
    this.kahootImage,
    required this.visibility,
    this.themes,
    required this.author,
    required this.createdAt,
    this.playCount,
    required this.questions,
  });
}