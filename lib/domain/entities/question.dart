import 'answer.dart';

enum QuestionType { quiz, trueFalse }

extension QuestionTypeX on QuestionType {
  String toApiString() {
    switch (this) {
      case QuestionType.quiz:
        return 'quiz';
      case QuestionType.trueFalse:
        return 'true_false';
    }
  }

  static QuestionType fromApiString(String s) {
    switch (s) {
      case 'quiz':
        return QuestionType.quiz;
      case 'true_false':
      case 'trueFalse':
        return QuestionType.trueFalse;
      case 'multiple_choice':
        return QuestionType.quiz;
      default:
        return QuestionType.quiz;
    }
  }
}

class Question {
  final String? id;
  final String? quizId;
  final String text;
  final String? mediaId;
  final QuestionType type;
  final int timeLimit;
  final int points;
  final List<Answer> answers;

  Question({
    this.id,
    this.quizId,
    required this.text,
    this.mediaId,
    required this.type,
    required this.timeLimit,
    required this.points,
    required this.answers,
  });
}