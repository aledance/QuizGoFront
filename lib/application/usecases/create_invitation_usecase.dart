import '../../domain/repositories/group_repository.dart';

class CreateInvitationUseCase {
  final GroupRepository repository;
  CreateInvitationUseCase(this.repository);

  Future<String> call(String groupId, {required String expiresIn}) async => repository.createInvitation(groupId, expiresIn: expiresIn);
}
