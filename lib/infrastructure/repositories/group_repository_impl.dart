import 'package:meta/meta.dart';

import '../../domain/entities/group.dart';
import '../../domain/entities/leaderboard.dart';
import '../../domain/repositories/group_repository.dart';
import '../dtos/groups_dtos.dart' hide LeaderboardEntry, QuizTopPlayer;
import '../services/groups_api.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupsApi api;
  GroupRepositoryImpl({required this.api});

  @override
  Future<List<Group>> getGroups() async {
    final dtos = await api.getGroups();
    return dtos
        .map((d) => Group(
              id: d.id,
              name: d.name,
              role: d.role,
              memberCount: d.memberCount,
              createdAt: d.createdAt,
            ))
        .toList();
  }

  @override
  Future<Group> createGroup(String name) async {
    final resp = await api.createGroup(GroupCreateRequest(name: name));
    return Group(
      id: resp.id,
      name: resp.name,
      role: 'admin',
      memberCount: resp.memberCount,
      createdAt: resp.createdAt,
    );
  }

  @override
  Future<Group> patchGroup(String groupId, {String? name, String? description}) async {
    final dto = GroupPartialUpdate(name: name, description: description);
    final res = await api.patchGroup(groupId, dto);
    return Group(
      id: res['id'] as String,
      name: res['name'] as String,
      role: 'member',
      memberCount: (res['memberCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(res['updatedAt'] as String),
      description: res['description'] as String?,
    );
  }

  @override
  Future<void> deleteGroup(String groupId) async => api.deleteGroup(groupId);

  @override
  Future<void> deleteMember(String groupId, String memberId) async => api.deleteMember(groupId, memberId);

  @override
  Future<void> transferAdmin(String groupId, String newAdminId) async {
    await api.transferAdmin(groupId, TransferAdminRequest(newAdminId: newAdminId));
  }

  @override
  Future<String> createInvitation(String groupId, {required String expiresIn}) async {
    final resp = await api.createInvitation(groupId, InvitationRequest(expiresIn: expiresIn));
    return resp.invitationLink;
  }

  @override
  Future<Group> joinGroupWithToken(String token) async {
    final resp = await api.joinGroup(JoinRequest(invitationToken: token));
    return Group(
      id: resp.groupId,
      name: resp.groupName,
      role: resp.role,
      memberCount: 0,
      createdAt: resp.joinedAt,
    );
  }

  @override
  Future<void> assignQuiz(String groupId, String quizId, DateTime from, DateTime to) async {
    await api.assignQuiz(groupId, AssignQuizRequest(quizId: quizId, availableFrom: from, availableTo: to));
  }

  @override
  Future<List<LeaderboardEntry>> getGroupLeaderboard(String groupId) async {
    final list = await api.getGroupLeaderboard(groupId);
    return list
        .map((e) => LeaderboardEntry(
              userId: e.userId,
              name: e.name,
              completedQuizzes: e.completedQuizzes,
              totalPoints: e.totalPoints,
              position: e.position,
            ))
        .toList();
  }

  @override
  Future<List<QuizTopPlayer>> getQuizLeaderboard(String groupId, String quizId) async {
    final resp = await api.getQuizLeaderboard(groupId, quizId);
    return resp.topPlayers
        .map((p) => QuizTopPlayer(userId: p.userId, name: p.name, score: p.score))
        .toList();
  }
}
