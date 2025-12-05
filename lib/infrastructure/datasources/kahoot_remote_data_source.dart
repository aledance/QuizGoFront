import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../dtos/kahoot_dto.dart';

class KahootRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  KahootRemoteDataSource({required this.client, String? baseUrl})
      : baseUrl = baseUrl ?? 'https://backcomun-production.up.railway.app';

  Future<KahootDto> createKahoot(KahootDto dto) async {
    final uri = Uri.parse('$baseUrl/kahoots');
    final authorId = dto.author['authorId'] as String? ?? '';
    try {
      final body = jsonEncode(dto.toJsonRequest(authorId: authorId));
      print('DEBUG: createKahoot body: $body');
      final res = await client.post(uri, headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 201) {
        return KahootDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      final reqId = res.headers['x-railway-request-id'] ?? res.headers['x-request-id'] ?? '';
      throw Exception('Failed to create kahoot: ${res.statusCode} ${res.body} (request-id: $reqId)');
    } catch (e, st) {
      // Provide clearer error for frontend / web (CORS / network) and log stack for debugging
      // ignore: avoid_print
      print('createKahoot error: $e\n$st');
      throw Exception('Network/create error: $e');
    }
  }

  Future<KahootDto> updateKahoot(String kahootId, KahootDto dto) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final authorId = dto.author['authorId'] as String? ?? '';
    try {
      final body = jsonEncode(dto.toJsonRequest(authorId: authorId));
      print('DEBUG: updateKahoot body: $body');
      final res = await client.put(uri, headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 200) {
        return KahootDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      final reqId = res.headers['x-railway-request-id'] ?? res.headers['x-request-id'] ?? '';
      throw Exception('Failed to update kahoot: ${res.statusCode} ${res.body} (request-id: $reqId)');
    } catch (e, st) {
      // ignore: avoid_print
      print('updateKahoot error: $e\n$st');
      throw Exception('Network/update error: $e');
    }
  }

  Future<KahootDto> getKahootById(String kahootId) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    try {
      final res = await client.get(uri, headers: {'Accept': 'application/json'});
      if (res.statusCode == 200) {
        return KahootDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      final reqId = res.headers['x-railway-request-id'] ?? res.headers['x-request-id'] ?? '';
      throw Exception('Failed to get kahoot: ${res.statusCode} ${res.body} (request-id: $reqId)');
    } catch (e, st) {
      // ignore: avoid_print
      print('getKahootById error: $e\n$st');
      throw Exception('Network/get error: $e');
    }
  }


  Future<void> deleteKahoot(String kahootId, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final headers = <String, String>{};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    try {
      final res = await client.delete(uri, headers: headers);
      if (res.statusCode == 200 || res.statusCode == 204) return;
      final reqId = res.headers['x-railway-request-id'] ?? res.headers['x-request-id'] ?? '';
      throw Exception('Failed to delete kahoot: ${res.statusCode} ${res.body} (request-id: $reqId)');
    } catch (e, st) {
      // ignore: avoid_print
      print('deleteKahoot error: $e\n$st');
      throw Exception('Network/delete error: $e');
    }
  }


  Future<List<Map<String, dynamic>>> listKahoots() async {
    final uri = Uri.parse('$baseUrl/kahoots');
    try {
      final res = await client.get(uri, headers: {'Accept': 'application/json'});
      if (res.statusCode == 200) {
        final parsed = jsonDecode(res.body) as List<dynamic>;
        return parsed.cast<Map<String, dynamic>>();
      }
      final reqId = res.headers['x-railway-request-id'] ?? res.headers['x-request-id'] ?? '';
      throw Exception('Failed to list kahoots: ${res.statusCode} ${res.body} (request-id: $reqId)');
    } catch (e, st) {
      // ignore: avoid_print
      print('listKahoots error: $e\n$st');
      throw Exception('Network/list error: $e');
    }
  }


  Future<Map<String, dynamic>> patchKahoot(String kahootId, Map<String, dynamic> data, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/kahoots/$kahootId');
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';

    try {
      final req = http.Request('PATCH', uri);
      req.headers.addAll(headers);
      req.body = jsonEncode(data);
      final streamed = await client.send(req);
      final res = await http.Response.fromStream(streamed);
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      final reqId = res.headers['x-railway-request-id'] ?? res.headers['x-request-id'] ?? '';
      throw Exception('Failed to patch kahoot: ${res.statusCode} ${res.body} (request-id: $reqId)');
    } catch (e, st) {
      // ignore: avoid_print
      print('patchKahoot error: $e\n$st');
      throw Exception('Network/patch error: $e');
    }
  }
}