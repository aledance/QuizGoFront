import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';

class CreateGroupUseCase {
  final GroupRepository repository;
  CreateGroupUseCase(this.repository);

  Future<Group> call(String name) async => repository.createGroup(name);
}
