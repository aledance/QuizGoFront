import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';

class CreateGroupUseCase {
  final GroupRepository repository;
  CreateGroupUseCase(this.repository);

  Future<Group> call(String name, {String? imagePath}) async => repository.createGroup(name, imagePath: imagePath);
}
