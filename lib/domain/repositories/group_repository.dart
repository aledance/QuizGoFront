import '../entities/group.dart';
import '../entities/leaderboard.dart';

abstract class GroupRepository {
  Future<List<Group>> getGroups();
  Future<Group> createGroup(String name);
  Future<Group> patchGroup(String groupId, {String? name, String? description});
  Future<void> deleteGroup(String groupId);
  Future<void> deleteMember(String groupId, String memberId);
  Future<void> transferAdmin(String groupId, String newAdminId);
  Future<String> createInvitation(String groupId, {required String expiresIn});
  Future<Group> joinGroupWithToken(String token);
  Future<void> assignQuiz(String groupId, String quizId, DateTime from, DateTime to);
  Future<List<LeaderboardEntry>> getGroupLeaderboard(String groupId);
  Future<List<QuizTopPlayer>> getQuizLeaderboard(String groupId, String quizId);
}
