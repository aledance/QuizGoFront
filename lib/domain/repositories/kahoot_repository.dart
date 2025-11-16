import '../entities/kahoot.dart';

abstract class KahootRepository {
  Future<Kahoot> createKahoot(Kahoot kahoot);
  Future<Kahoot> updateKahoot(String kahootId, Kahoot kahoot);
  Future<Kahoot> getKahootById(String kahootId);
  Future<void> deleteKahoot(String kahootId);
}
