import 'dart:convert';

class SubmitResponseRequest {
  final int slideIndex;
  final int answerIndex;
  final int timeElapsedMs;

  SubmitResponseRequest({required this.slideIndex, required this.answerIndex, required this.timeElapsedMs});

  Map<String, dynamic> toJson() => {
        'slideIndex': slideIndex,
        'answerIndex': answerIndex,
        'timeElapsedMs': timeElapsedMs,
      };
}

class SubmitResponseResult {
  final String status;
  final bool isCorrect;
  final int pointsEarned;
  final int currentScore;

  SubmitResponseResult({required this.status, required this.isCorrect, required this.pointsEarned, required this.currentScore});

  factory SubmitResponseResult.fromJson(Map<String, dynamic> json) => SubmitResponseResult(
        status: json['status'] as String,
        isCorrect: json['isCorrect'] as bool,
        pointsEarned: json['pointsEarned'] as int,
        currentScore: json['currentScore'] as int,
      );

  @override
  String toString() => jsonEncode({'status': status, 'isCorrect': isCorrect, 'pointsEarned': pointsEarned, 'currentScore': currentScore});
}
