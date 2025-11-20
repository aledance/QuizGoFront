import '../../domain/entities/question.dart';
import 'answer_dto.dart';

class QuestionDto {
  final String? id;
  final String? quizId;
  final String text;
  final String? mediaId;
  final String type;
  final int timeLimit;
  final int points;
  final List<AnswerDto> answers;

  QuestionDto({
    this.id,
    this.quizId,
    required this.text,
    this.mediaId,
    required this.type,
    required this.timeLimit,
    required this.points,
    required this.answers,
  });

  factory QuestionDto.fromJson(Map<String, dynamic> json) => QuestionDto(
        id: json['id'] as String?,
        quizId: json['quizId'] as String?,
        text: (json['text'] as String?) ?? (json['questionText'] as String?) ?? '',
        mediaId: json['mediaId'] as String?,
        type: (json['type'] as String?) ?? (json['questionType'] as String?) ?? 'quiz',
        timeLimit: json['timeLimit'] as int? ?? 0,
        points: json['points'] as int? ?? 0,
        answers: (json['answers'] as List<dynamic>? ?? [])
            .map((a) => AnswerDto.fromJson(a as Map<String, dynamic>))
            .toList(),
      );


  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (quizId != null) 'quizId': quizId,
        'questionText': text,
        'mediaId': mediaId,

        'questionType': type,
        'timeLimit': timeLimit,
        'points': points,
        'answers': answers.map((a) => a.toJson()).toList(),
      };

  Question toEntity() => Question(
        id: id,
        quizId: quizId,
        text: text,
        mediaId: mediaId,
        type: QuestionTypeX.fromApiString(type),
        timeLimit: timeLimit,
        points: points,
        answers: answers.map((a) => a.toEntity()).toList(),
      );

  factory QuestionDto.fromEntity(Question q) => QuestionDto(
        id: q.id,
        quizId: q.quizId,
        text: q.text,
        mediaId: q.mediaId,
        type: q.type.toApiString(),
        timeLimit: q.timeLimit,
        points: q.points,
        answers: q.answers.map((a) => AnswerDto.fromEntity(a)).toList(),
      );
}