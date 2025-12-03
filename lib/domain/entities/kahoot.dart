import 'author.dart';
import 'question.dart';

class Kahoot {
  final String? id;
  final String title;
  final String description;
  final String? coverImageId;
  final String visibility;
  final String? status;
  final String? category;
  final String? themeId;
  final Author author;
  final DateTime createdAt;
  final List<Question> questions;

  Kahoot({
    this.id,
    required this.title,
    required this.description,
    this.coverImageId,
    required this.visibility,
    required this.status,
    required this.category,
    this.themeId,
    required this.author,
    required this.createdAt,
    required this.questions,
  });
}