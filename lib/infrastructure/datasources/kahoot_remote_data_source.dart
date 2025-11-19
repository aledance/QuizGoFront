import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/kahoot_dto.dart';

class KahootRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  KahootRemoteDataSource({required this.client, this.baseUrl = 'http://localhost:3000'});

  Future<KahootDto> createKahoot(KahootDto dto) async {
    final uri = Uri.parse('$baseUrl/kahoots');
    final authorId = dto.author['authorId'] as String? ?? '';
    final res = await client.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(dto.toJsonRequest(authorId: authorId)));
    if (res.statusCode == 201) {
      return KahootDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to create kahoot: ${res.statusCode} ${res.body}');
  }

  Future<KahootDto> updateKahoot(String kahootId, KahootDto dto) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final authorId = dto.author['authorId'] as String? ?? '';
    final res = await client.put(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(dto.toJsonRequest(authorId: authorId)));
    if (res.statusCode == 200) {
      return KahootDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to update kahoot: ${res.statusCode} ${res.body}');
  }

  Future<KahootDto> getKahootById(String kahootId) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final res = await client.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode == 200) {
      return KahootDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to get kahoot: ${res.statusCode} ${res.body}');
  }

  /// Delete kahoot. Accepts optional [authToken] to send Authorization header for admin actions.
  Future<void> deleteKahoot(String kahootId, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final headers = <String, String>{};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final res = await client.delete(uri, headers: headers);
    // Accept 200 or 204 as success (mock server returns 204)
    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception('Failed to delete kahoot: ${res.statusCode} ${res.body}');
  }

  /// List all kahoots (returns raw map list from server)
  Future<List<Map<String, dynamic>>> listKahoots() async {
    final uri = Uri.parse('$baseUrl/kahoots');
    final res = await client.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body) as List<dynamic>;
      return parsed.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to list kahoots: ${res.statusCode} ${res.body}');
  }

  /// Admin PATCH for kahoot moderation. Sends optional Authorization token.
  Future<Map<String, dynamic>> patchKahoot(String kahootId, Map<String, dynamic> data, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    // Use HTTP PATCH via a generic request
    final req = http.Request('PATCH', uri);
    req.headers.addAll(headers);
    req.body = jsonEncode(data);
    final streamed = await client.send(req);
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to patch kahoot: ${res.statusCode} ${res.body}');
  }
}
