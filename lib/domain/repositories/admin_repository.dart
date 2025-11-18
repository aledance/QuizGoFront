import '../entities/user.dart';

abstract class AdminRepository {
  Future<List<User>> getUsers({int page = 1, int limit = 20, String? search, String? role});
  Future<User> createUser(User user);
  Future<User> updateUser(String id, User user);
  Future<User> patchUser(String id, Map<String, dynamic> changes);
  Future<void> deleteUser(String id);
}
