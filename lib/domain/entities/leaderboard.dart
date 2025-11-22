class LeaderboardEntry {
  final String userId;
  final String name;
  final int completedQuizzes;
  final int totalPoints;
  final int position;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.completedQuizzes,
    required this.totalPoints,
    required this.position,
  });
}

class QuizTopPlayer {
  final String userId;
  final String name;
  final int score;

  QuizTopPlayer({required this.userId, required this.name, required this.score});
}
