import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  NotificationRemoteDataSource({required this.client, this.baseUrl = 'http://localhost:3000'});

  /// Send a notification as admin. Payload should include at least: title, message, audience ('all'|'user').
  Future<Map<String, dynamic>> sendNotification(Map<String, dynamic> payload, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/admin/notifications');
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final res = await client.post(uri, headers: headers, body: jsonEncode(payload));
    if (res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to send notification: ${res.statusCode} ${res.body}');
  }

  /// List sent notifications (admin)
  Future<List<Map<String, dynamic>>> listNotifications({String? authToken}) async {
    final uri = Uri.parse('$baseUrl/admin/notifications');
    final headers = <String, String>{'Accept': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final res = await client.get(uri, headers: headers);
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body) as List<dynamic>;
      return parsed.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to list notifications: ${res.statusCode} ${res.body}');
  }

  /// Get a single notification by id (admin)
  Future<Map<String, dynamic>> getNotificationById(String id, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/admin/notifications/$id');
    final headers = <String, String>{'Accept': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final res = await client.get(uri, headers: headers);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to get notification: ${res.statusCode} ${res.body}');
  }
}
