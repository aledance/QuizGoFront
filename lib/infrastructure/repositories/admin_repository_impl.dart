import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/repositories/admin_repository.dart';
import 'package:flutter_application_1/infrastructure/datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remote;

  AdminRepositoryImpl({required this.remote});

  @override
  Future<User> createUser(User user) async {
    final json = await remote.createUser(user.toJson());
    return User.fromJson(json);
  }

  @override
  Future<void> deleteUser(String id) async {
    await remote.deleteUser(id);
  }

  @override
  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 20, String? search, String? role, String? orderBy, String? order, String? status}) async {
    final res = await remote.fetchUsers(page: page, limit: limit, search: search, role: role, orderBy: orderBy, order: order, status: status);
    return res;
  }

  @override
  Future<User> patchUser(String id, Map<String, dynamic> changes) async {
    final json = await remote.patchUser(id, changes);
    return User.fromJson(json);
  }

  @override
  Future<User> updateUser(String id, User user) async {
    final json = await remote.updateUser(id, user.toJson());
    return User.fromJson(json);
  }
}
