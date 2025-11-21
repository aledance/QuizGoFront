import '../../domain/entities/answer.dart';

class AnswerDto {
  final String? id;
  final String? questionId;
  final String? text;
  final String? mediaId;
  final bool isCorrect;

  AnswerDto({this.id, this.questionId, this.text, this.mediaId, required this.isCorrect});

  factory AnswerDto.fromJson(Map<String, dynamic> json) => AnswerDto(
        id: json['id'] as String?,
        questionId: json['questionId'] as String?,
        text: (json['text'] as String?) ?? (json['answerText'] as String?),
        mediaId: json['mediaId'] as String?,
        isCorrect: json['isCorrect'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (questionId != null) 'questionId': questionId,

        'answerText': text,
        'mediaId': mediaId,
        'isCorrect': isCorrect,
      };

  Answer toEntity() => Answer(
        id: id,
        questionId: questionId,
        text: text,
        mediaId: mediaId,
        isCorrect: isCorrect,
      );

  factory AnswerDto.fromEntity(Answer e) => AnswerDto(
        id: e.id,
        questionId: e.questionId,
        text: e.text,
        mediaId: e.mediaId,
        isCorrect: e.isCorrect,
      );
}