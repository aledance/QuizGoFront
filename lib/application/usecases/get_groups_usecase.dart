import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';

class GetGroupsUseCase {
  final GroupRepository repository;
  GetGroupsUseCase(this.repository);

  Future<List<Group>> call() async => repository.getGroups();
}
