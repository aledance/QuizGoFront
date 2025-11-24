class PlayerRankingDto {
  final int position;
  final String username;
  final int score;
  final int correctAnswers;

  PlayerRankingDto({
    required this.position,
    required this.username,
    required this.score,
    required this.correctAnswers,
  });

  factory PlayerRankingDto.fromJson(Map<String, dynamic> json) {
    return PlayerRankingDto(
      position: json['position'] as int,
      username: json['username'] as String,
      score: json['score'] as int,
      correctAnswers: json['correctAnswers'] as int,
    );
  }
}

class QuestionAnalysisDto {
  final int questionIndex;
  final String questionText;
  final double correctPercentage;

  QuestionAnalysisDto({
    required this.questionIndex,
    required this.questionText,
    required this.correctPercentage,
  });

  factory QuestionAnalysisDto.fromJson(Map<String, dynamic> json) {
    return QuestionAnalysisDto(
      questionIndex: json['questionIndex'] as int,
      questionText: json['questionText'] as String,
      correctPercentage: (json['correctPercentage'] as num).toDouble(),
    );
  }
}

class SessionReportDto {
  final String reportId;
  final String sessionId;
  final String title;
  final DateTime executionDate;
  final List<PlayerRankingDto> playerRanking;
  final List<QuestionAnalysisDto> questionAnalysis;

  SessionReportDto({
    required this.reportId,
    required this.sessionId,
    required this.title,
    required this.executionDate,
    required this.playerRanking,
    required this.questionAnalysis,
  });

  factory SessionReportDto.fromJson(Map<String, dynamic> json) {
    return SessionReportDto(
      reportId: json['reportId'] as String,
      sessionId: json['sessionId'] as String,
      title: json['title'] as String,
      executionDate: DateTime.parse(json['executionDate'] as String),
      playerRanking: (json['playerRanking'] as List<dynamic>?)
              ?.map((e) => PlayerRankingDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      questionAnalysis: (json['questionAnalysis'] as List<dynamic>?)
              ?.map((e) => QuestionAnalysisDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
