class Answer {
  final String? id;
  final String? questionId;
  final String? text;
  final String? mediaId;
  final bool isCorrect;

  Answer({
    this.id,
    this.questionId,
    this.text,
    this.mediaId,
    required this.isCorrect,
  });
}