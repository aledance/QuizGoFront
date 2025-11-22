import '../../domain/repositories/group_repository.dart';

class DeleteMemberUseCase {
  final GroupRepository repository;
  DeleteMemberUseCase(this.repository);

  Future<void> call(String groupId, String memberId) async => repository.deleteMember(groupId, memberId);
}
