class QuestionResultDto {
  final int questionIndex;
  final String questionText;
  final bool isCorrect;
  final String playerAnswer;
  final int timeTakenMs;

  QuestionResultDto({
    required this.questionIndex,
    required this.questionText,
    required this.isCorrect,
    required this.playerAnswer,
    required this.timeTakenMs,
  });

  factory QuestionResultDto.fromJson(Map<String, dynamic> json) {
    return QuestionResultDto(
      questionIndex: json['questionIndex'] as int,
      questionText: json['questionText'] as String,
      isCorrect: json['isCorrect'] as bool,
      playerAnswer: json['playerAnswer'] as String,
      timeTakenMs: json['timeTakenMs'] as int,
    );
  }
}

class PersonalResultDto {
  final String kahootId;
  final String title;
  final String userId;
  final int finalScore;
  final int correctAnswers;
  final int totalQuestions;
  final int averageTimeMs;
  final int rankingPosition;
  final List<QuestionResultDto> questionResults;

  PersonalResultDto({
    required this.kahootId,
    required this.title,
    required this.userId,
    required this.finalScore,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.averageTimeMs,
    required this.rankingPosition,
    required this.questionResults,
  });

  factory PersonalResultDto.fromJson(Map<String, dynamic> json) {
    return PersonalResultDto(
      kahootId: json['kahootId'] as String,
      title: json['title'] as String,
      userId: json['userId'] as String,
      finalScore: json['finalScore'] as int,
      correctAnswers: json['correctAnswers'] as int,
      totalQuestions: json['totalQuestions'] as int,
      averageTimeMs: json['averageTimeMs'] as int,
      rankingPosition: json['rankingPosition'] as int,
      questionResults: (json['questionResults'] as List<dynamic>?)
              ?.map((e) => QuestionResultDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
