import '../../domain/repositories/group_repository.dart';

class AssignQuizUseCase {
  final GroupRepository repository;
  AssignQuizUseCase(this.repository);

  Future<void> call(String groupId, String quizId, DateTime from, DateTime to) async =>
      repository.assignQuiz(groupId, quizId, from, to);
}
