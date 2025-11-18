import '../domain/entities/kahoot.dart';
import '../domain/repositories/kahoot_repository.dart';
import 'usecases/create_kahoot.dart';
import 'usecases/update_kahoot.dart';
import 'usecases/get_kahoot.dart';
import 'usecases/delete_kahoot.dart';

/// Application layer service that composes use-cases. It depends on the
/// repository interface so it remains independent of infrastructure.
class KahootAppService {
  final CreateKahoot _create;
  final UpdateKahoot _update;
  final GetKahoot _get;
  final DeleteKahoot _delete;

  KahootAppService(KahootRepository repository)
      : _create = CreateKahoot(repository),
        _update = UpdateKahoot(repository),
        _get = GetKahoot(repository),
        _delete = DeleteKahoot(repository);

  Future<Kahoot> create(Kahoot k) => _create.call(k);
  Future<Kahoot> update(String id, Kahoot k) => _update.call(id, k);
  Future<Kahoot> getById(String id) => _get.call(id);
  Future<void> delete(String id) => _delete.call(id);
}
