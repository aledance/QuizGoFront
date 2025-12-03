import 'author.dart';
import 'question.dart';

class Kahoot {
  final String? id;
  final String title;
  final String description;
  final String? coverImageId;
  final String? category;
  final String? status;
  final String visibility;
  final String? themeId;
  final Author author;
  final DateTime createdAt;
  final List<Question> questions;

  Kahoot({
    this.id,
    required this.title,
    required this.description,
    this.coverImageId,
    this.category,
    this.status,
    required this.visibility,
    this.themeId,
    required this.author,
    required this.createdAt,
    required this.questions,
  });
}