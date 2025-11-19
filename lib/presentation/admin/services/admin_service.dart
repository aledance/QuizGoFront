import 'package:http/http.dart' as http;
import 'package:flutter_application_1/infrastructure/datasources/admin_remote_data_source.dart';
import 'package:flutter_application_1/infrastructure/repositories/admin_repository_impl.dart';
import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/entities/paginated_users.dart';

class AdminService {
  final AdminRepositoryImpl _repo;

  AdminService({required String baseUrl}) : _repo = AdminRepositoryImpl(remote: AdminRemoteDataSource(client: http.Client(), baseUrl: baseUrl));

  Future<PaginatedUsers> getUsers({int page = 1, int limit = 20, String? search, String? role, String? orderBy, String? order, String? status}) => _repo.getUsers(page: page, limit: limit, search: search, role: role, orderBy: orderBy, order: order, status: status);
  Future<User> createUser(User user) => _repo.createUser(user);
  Future deleteUser(String id) => _repo.deleteUser(id);
  Future<User> updateUser(String id, User user) => _repo.updateUser(id, user);
  Future<User> patchUser(String id, Map<String, dynamic> changes) => _repo.patchUser(id, changes);
}
