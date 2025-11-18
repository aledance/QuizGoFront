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

  Future<void> deleteKahoot(String kahootId) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final res = await client.delete(uri);
    if (res.statusCode == 200) return;
    throw Exception('Failed to delete kahoot: ${res.statusCode} ${res.body}');
  }
}
