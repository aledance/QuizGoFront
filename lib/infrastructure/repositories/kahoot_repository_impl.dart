import '../../domain/entities/kahoot.dart';
import '../../domain/repositories/kahoot_repository.dart';
import '../datasources/kahoot_remote_data_source.dart';
import '../dtos/kahoot_dto.dart';

class KahootRepositoryImpl implements KahootRepository {
  final KahootRemoteDataSource remote;

  KahootRepositoryImpl({required this.remote});

  @override
  Future<Kahoot> createKahoot(Kahoot kahoot) async {
    final dto = KahootDto.fromEntity(kahoot);
    final created = await remote.createKahoot(dto);
    return created.toEntity();
  }

  @override
  Future<void> deleteKahoot(String kahootId) async {
    return remote.deleteKahoot(kahootId);
  }

  @override
  Future<Kahoot> getKahootById(String kahootId) async {
    final dto = await remote.getKahootById(kahootId);
    return dto.toEntity();
  }

  @override
  Future<Kahoot> updateKahoot(String kahootId, Kahoot kahoot) async {
    final dto = KahootDto.fromEntity(kahoot);
    final updated = await remote.updateKahoot(kahootId, dto);
    return updated.toEntity();
  }
}