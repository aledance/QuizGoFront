import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final String authToken;

  AdminRemoteDataSource({required this.client, required this.baseUrl, this.authToken = 'admin_token'});

  /// Fetch users and return both data and pagination info when available.
  Future<Map<String, dynamic>> fetchUsers({int page = 1, int limit = 20, String? search, String? role, String? orderBy, String? order, String? status}) async {
    final params = <String, String>{'page': page.toString(), 'limit': limit.toString()};
    if (search != null && search.isNotEmpty) params['q'] = search;
    if (role != null && role.isNotEmpty) params['role'] = role;
    if (orderBy != null && orderBy.isNotEmpty) params['orderBy'] = orderBy;
    if (order != null && order.isNotEmpty) params['order'] = order;
    if (status != null && status.isNotEmpty) params['status'] = status;

    final uri = Uri.parse('$baseUrl/admin/users').replace(queryParameters: params);
    final res = await client.get(uri);
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      if (body is Map && body.containsKey('data')) {
        final data = (body['data'] as List<dynamic>).cast<Map<String, dynamic>>();
        final pagination = (body['pagination'] as Map<String, dynamic>? ) ?? <String, dynamic>{};
        return {'data': data, 'pagination': pagination};
      }
      if (body is List) return {'data': body.cast<Map<String, dynamic>>(), 'pagination': {}};
      throw Exception('Unexpected response format for users');
    }
    throw Exception('Failed to load users: ${res.statusCode}');
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/admin/users');
    final res = await client.post(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(data));
    if (res.statusCode == 201) return json.decode(res.body) as Map<String, dynamic>;
    throw Exception('Failed to create user: ${res.statusCode}');
  }

  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/admin/users/$id');
    final res = await client.put(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(data));
    if (res.statusCode == 200) return json.decode(res.body) as Map<String, dynamic>;
    throw Exception('Failed to update user: ${res.statusCode}');
  }

  Future<void> deleteUser(String id) async {
    final uri = Uri.parse('$baseUrl/admin/users/$id');
    final headers = <String, String>{};
    if (authToken.isNotEmpty) headers['authorization'] = 'Bearer $authToken';
    final res = await client.delete(uri, headers: headers);
    if (res.statusCode == 204) return;
    throw Exception('Failed to delete user: ${res.statusCode}');
  }

  Future<Map<String, dynamic>> patchUser(String id, Map<String, dynamic> changes) async {
    final uri = Uri.parse('$baseUrl/admin/users/$id');
    // http package has no direct patch method in older versions, but client.patch exists
    final headers = {'Content-Type': 'application/json'};
    if (authToken.isNotEmpty) headers['authorization'] = 'Bearer $authToken';
    final res = await client.patch(uri, headers: headers, body: json.encode(changes));
    if (res.statusCode == 200) return json.decode(res.body) as Map<String, dynamic>;
    throw Exception('Failed to patch user: ${res.statusCode}');
  }
}
