import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';

class JoinGroupUseCase {
  final GroupRepository repository;
  JoinGroupUseCase(this.repository);

  Future<Group> call(String invitationToken) async => repository.joinGroupWithToken(invitationToken);
}
