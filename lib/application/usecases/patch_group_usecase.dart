import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';

class PatchGroupUseCase {
  final GroupRepository repository;
  PatchGroupUseCase(this.repository);

  Future<Group> call(String groupId, {String? name, String? description}) async =>
      repository.patchGroup(groupId, name: name, description: description);
}
