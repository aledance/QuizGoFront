import '../entities/user.dart';

abstract class AdminRepository {

  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 20, String? search, String? role, String? orderBy, String? order, String? status});
  Future<User> createUser(User user);
  Future<User> updateUser(String id, User user);
  Future<User> patchUser(String id, Map<String, dynamic> changes);
  Future<void> deleteUser(String id);
  Future<Map<String, dynamic>> getMetrics();

  Future<Map<String, dynamic>> seed();
}