import '../entities/user.dart';

abstract class AdminRepository {
  /// Returns a map with keys: 'data' => List<Map<String,dynamic>> and optional 'pagination' => Map
  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 20, String? search, String? role, String? orderBy, String? order, String? status});
  Future<User> createUser(User user);
  Future<User> updateUser(String id, User user);
  Future<User> patchUser(String id, Map<String, dynamic> changes);
  Future<void> deleteUser(String id);
}
