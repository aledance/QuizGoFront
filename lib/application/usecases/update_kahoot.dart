import '../../domain/entities/kahoot.dart';
import '../../domain/repositories/kahoot_repository.dart';

class UpdateKahoot {
  final KahootRepository repository;

  UpdateKahoot(this.repository);

  Future<Kahoot> call(String id, Kahoot kahoot) async {
    return repository.updateKahoot(id, kahoot);
  }
}
