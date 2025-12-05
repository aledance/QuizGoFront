import '../../domain/entities/leaderboard.dart';
import '../../domain/repositories/group_repository.dart';

class GetQuizLeaderboardUseCase {
  final GroupRepository repository;
  GetQuizLeaderboardUseCase(this.repository);

  Future<List<QuizTopPlayer>> call(String groupId, String quizId) async => repository.getQuizLeaderboard(groupId, quizId);
}
