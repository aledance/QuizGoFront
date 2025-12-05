import '../../domain/entities/group.dart';
import '../../domain/entities/leaderboard.dart';
import '../../domain/repositories/group_repository.dart';

class SimulatedGroupRepository implements GroupRepository {
  final List<Group> _groups = [
    Group(
      id: 'g1',
      name: 'Matemáticas Avanzadas',
      role: 'admin',
      memberCount: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      description: 'Grupo de estudio para cálculo y álgebra',
      imageUrl: 'https://picsum.photos/seed/math/200/200',
    ),
    Group(
      id: 'g2',
      name: 'Historia del Arte',
      role: 'member',
      memberCount: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Repaso para el examen final',
      imageUrl: 'https://picsum.photos/seed/art/200/200',
    ),
    Group(
      id: 'g3',
      name: 'Ciencias Naturales',
      role: 'member',
      memberCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      description: 'Biología y Química',
      imageUrl: 'https://picsum.photos/seed/science/200/200',
    ),
  ];

  @override
  Future<List<Group>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _groups;
  }

  @override
  Future<Group> createGroup(String name, {String? imagePath}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newGroup = Group(
      id: 'g${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      role: 'admin',
      memberCount: 1,
      createdAt: DateTime.now(),
      description: 'Nuevo grupo creado',
      imageUrl: imagePath, // In a real app, this would be a URL after upload
    );
    _groups.add(newGroup);
    return newGroup;
  }

  @override
  Future<Group> patchGroup(String groupId, {String? name, String? description}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real simulation we would update the list, but for now just return a dummy
    return Group(
      id: groupId,
      name: name ?? 'Updated Name',
      role: 'admin',
      memberCount: 5,
      createdAt: DateTime.now(),
      description: description,
    );
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _groups.removeWhere((g) => g.id == groupId);
  }

  @override
  Future<void> deleteMember(String groupId, String memberId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> transferAdmin(String groupId, String newAdminId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<String> createInvitation(String groupId, {required String expiresIn}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://quizgo.app/invite/$groupId';
  }

  @override
  Future<Group> joinGroupWithToken(String token) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newGroup = Group(
      id: 'g_joined_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Grupo Unido',
      role: 'member',
      memberCount: 10,
      createdAt: DateTime.now(),
      description: 'Te has unido mediante token',
    );
    _groups.add(newGroup);
    return newGroup;
  }

  @override
  Future<void> assignQuiz(String groupId, String quizId, DateTime from, DateTime to) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<LeaderboardEntry>> getGroupLeaderboard(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.generate(5, (index) {
      return LeaderboardEntry(
        userId: 'u$index',
        name: 'Estudiante ${index + 1}',
        completedQuizzes: 10 - index,
        totalPoints: (10 - index) * 1000,
        position: index + 1,
      );
    });
  }

  @override
  Future<List<QuizTopPlayer>> getQuizLeaderboard(String groupId, String quizId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.generate(3, (index) {
      return QuizTopPlayer(
        userId: 'u$index',
        name: 'Jugador Top ${index + 1}',
        score: (3 - index) * 1500,
      );
    });
  }
}
