import '../../domain/entities/leaderboard.dart';
import '../../domain/repositories/group_repository.dart';

class GetGroupLeaderboardUseCase {
  final GroupRepository repository;
  GetGroupLeaderboardUseCase(this.repository);

  Future<List<LeaderboardEntry>> call(String groupId) async => repository.getGroupLeaderboard(groupId);
}
