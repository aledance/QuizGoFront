import 'package:flutter/foundation.dart';

import '../../domain/entities/group.dart';
import '../../application/usecases/get_groups_usecase.dart';
import '../../application/usecases/create_group_usecase.dart';
import '../../application/usecases/join_group_usecase.dart';
import '../../application/usecases/get_leaderboard_usecase.dart';

class GroupsController extends ChangeNotifier {
  final GetGroupsUseCase getGroupsUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final JoinGroupUseCase joinGroupUseCase;
  final GetGroupLeaderboardUseCase getLeaderboardUseCase;

  bool loading = false;
  String? error;
  List<Group> groups = [];

  GroupsController({
    required this.getGroupsUseCase,
    required this.createGroupUseCase,
    required this.joinGroupUseCase,
    required this.getLeaderboardUseCase,
  });

  Future<void> loadGroups() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      groups = await getGroupsUseCase();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<Group?> createGroup(String name, {String? imagePath}) async {
    try {
      final g = await createGroupUseCase(name, imagePath: imagePath);
      groups.insert(0, g);
      notifyListeners();
      return g;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Group?> joinWithToken(String token) async {
    try {
      final g = await joinGroupUseCase(token);
      groups.insert(0, g);
      notifyListeners();
      return g;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<List<dynamic>?> getLeaderboard(String groupId) async {
    try {
      final board = await getLeaderboardUseCase(groupId);
      return board;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
