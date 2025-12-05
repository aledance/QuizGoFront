import '../../domain/repositories/group_repository.dart';

class TransferAdminUseCase {
  final GroupRepository repository;
  TransferAdminUseCase(this.repository);

  Future<void> call(String groupId, String newAdminId) async => repository.transferAdmin(groupId, newAdminId);
}
