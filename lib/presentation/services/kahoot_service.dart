import 'package:http/http.dart' as http;
import '../../domain/entities/author.dart';
import '../../domain/entities/kahoot.dart';
import '../../infrastructure/datasources/kahoot_remote_data_source.dart';
import '../../infrastructure/repositories/kahoot_repository_impl.dart';


class KahootService {
  final KahootRepositoryImpl _repo;

  KahootService({required String baseUrl}) : _repo = KahootRepositoryImpl(remote: KahootRemoteDataSource(client: http.Client(), baseUrl: baseUrl));

  Future<Kahoot> create(Kahoot kahoot) => _repo.createKahoot(kahoot);
  Future<Kahoot> update(String id, Kahoot kahoot) => _repo.updateKahoot(id, kahoot);
  Future<Kahoot> getById(String id) => _repo.getKahootById(id);
  Future<void> delete(String id) => _repo.deleteKahoot(id);
}


Kahoot exampleKahoot() => Kahoot(
      title: 'Nuevo Kahoot',
      description: 'Descripción ejemplo',
      visibility: 'private',
      coverImageId: null,
      themeId: null,
      status: 'draft',
      category: 'Tecnología',
      author: Author(authorId: '00000000-0000-0000-0000-000000000000', name: 'Tester'),
      createdAt: DateTime.now(),
      questions: [],
    );