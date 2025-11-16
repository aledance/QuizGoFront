import '../../domain/entities/kahoot.dart';
import '../../domain/repositories/kahoot_repository.dart';

class CreateKahoot {
  final KahootRepository repository;

  CreateKahoot(this.repository);

  Future<Kahoot> call(Kahoot kahoot) async {
    return repository.createKahoot(kahoot);
  }
}
