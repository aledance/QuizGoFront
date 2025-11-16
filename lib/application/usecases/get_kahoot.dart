import '../../domain/entities/kahoot.dart';
import '../../domain/repositories/kahoot_repository.dart';

class GetKahoot {
  final KahootRepository repository;

  GetKahoot(this.repository);

  Future<Kahoot> call(String id) async {
    return repository.getKahootById(id);
  }
}
