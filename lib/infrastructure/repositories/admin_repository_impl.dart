import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/entities/paginated_users.dart';
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
  Future<PaginatedUsers> getUsers({int page = 1, int limit = 20, String? search, String? role, String? orderBy, String? order, String? status}) async {
    final res = await remote.fetchUsers(page: page, limit: limit, search: search, role: role, orderBy: orderBy, order: order, status: status);
    final data = (res['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    final pagination = (res['pagination'] as Map<String, dynamic>? ) ?? <String, dynamic>{};
    final users = data.map((e) => User.fromJson(e)).toList();
    final pageNum = (pagination['page'] is int) ? pagination['page'] as int : int.tryParse((pagination['page'] ?? page).toString()) ?? page;
    final lim = (pagination['limit'] is int) ? pagination['limit'] as int : int.tryParse((pagination['limit'] ?? limit).toString()) ?? limit;
    final totalCount = (pagination['totalCount'] is int) ? pagination['totalCount'] as int : int.tryParse((pagination['totalCount'] ?? users.length).toString()) ?? users.length;
    final totalPages = (pagination['totalPages'] is int) ? pagination['totalPages'] as int : int.tryParse((pagination['totalPages'] ?? 1).toString()) ?? 1;
    return PaginatedUsers(data: users, page: pageNum, limit: lim, totalCount: totalCount, totalPages: totalPages);
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
