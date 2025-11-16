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

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'] as String?,
        questionId: json['questionId'] as String?,
        text: json['answerText'] as String?,
        mediaId: json['mediaId'] as String?,
        isCorrect: json['isCorrect'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'questionId': questionId,
        'answerText': text,
        'mediaId': mediaId,
        'isCorrect': isCorrect,
      };
}
