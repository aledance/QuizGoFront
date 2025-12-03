import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

class ThemeRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ThemeRemoteDataSource({required this.client, String? baseUrl})
      : baseUrl = baseUrl ?? (Platform.isAndroid ? 'http://10.0.2.2:3000' : 'https://backcomun-production.up.railway.app');

  Future<List<Map<String, dynamic>>> listThemes() async {
    final uri = Uri.parse('$baseUrl/themes');
    final res = await client.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body) as List<dynamic>;
      return parsed.cast<Map<String, dynamic>>();
    }
    // If the backend doesn't expose /themes, return an empty list instead of
    // throwing to avoid crashing the UI. Log the response for debugging.
    // ignore: avoid_print
    print('Theme list request failed: ${res.statusCode} ${res.body}');
    if (res.statusCode == 404) return <Map<String, dynamic>>[];
    throw Exception('Failed to list themes: ${res.statusCode} ${res.body}');
  }

  Future<Map<String, dynamic>> createTheme(Map<String, dynamic> data, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/themes');
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final res = await client.post(uri, headers: headers, body: jsonEncode(data));
    if (res.statusCode == 201) return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('Failed to create theme: ${res.statusCode} ${res.body}');
  }

  Future<Map<String, dynamic>> patchTheme(String id, Map<String, dynamic> data, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/themes/$id');
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final req = http.Request('PATCH', uri);
    req.headers.addAll(headers);
    req.body = jsonEncode(data);
    final streamed = await client.send(req);
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('Failed to patch theme: ${res.statusCode} ${res.body}');
  }

  Future<void> deleteTheme(String id, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/themes/$id');
    final headers = <String, String>{};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final res = await client.delete(uri, headers: headers);
    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception('Failed to delete theme: ${res.statusCode} ${res.body}');
  }
}