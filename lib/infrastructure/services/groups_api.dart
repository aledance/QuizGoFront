import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/groups_dtos.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

class GroupsApi {
  final String baseUrl; // e.g. http://localhost:8080
  String? token;
  final http.Client _client;

  GroupsApi({required this.baseUrl, this.token, http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path) => Uri.parse(baseUrl + path);

  Future<List<GroupSummary>> getGroups() async {
    final res = await _client.get(_uri('/api/groups'), headers: _headers());
    if (res.statusCode == 200) {
      final List<dynamic> arr = json.decode(res.body) as List<dynamic>;
      return arr.map((e) => GroupSummary.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw ApiException('Error getting groups', res.statusCode);
  }

  Future<GroupCreateResponse> createGroup(GroupCreateRequest req) async {
    final res = await _client.post(
      _uri('/api/groups'),
      headers: _headers(),
      body: json.encode(req.toJson()),
    );
    if (res.statusCode == 201) {
      return GroupCreateResponse.fromJson(json.decode(res.body) as Map<String, dynamic>);
    }
    throw ApiException('Error creating group: ${res.body}', res.statusCode);
  }

  Future<Map<String, dynamic>> patchGroup(String groupId, GroupPartialUpdate req) async {
    final res = await _client.patch(
      _uri('/api/groups/$groupId'),
      headers: _headers(),
      body: json.encode(req.toJson()),
    );
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw ApiException('Error updating group', res.statusCode);
  }

  Future<void> deleteGroup(String groupId) async {
    final res = await _client.delete(_uri('/api/groups/$groupId'), headers: _headers());
    if (res.statusCode == 204) return;
    throw ApiException('Error deleting group', res.statusCode);
  }

  Future<void> deleteMember(String groupId, String memberId) async {
    final res = await _client.delete(_uri('/api/groups/$groupId/members/$memberId'), headers: _headers());
    if (res.statusCode == 204) return;
    throw ApiException('Error deleting member', res.statusCode);
  }

  Future<TransferAdminResponse> transferAdmin(String groupId, TransferAdminRequest req) async {
    final res = await _client.patch(
      _uri('/api/groups/$groupId/transfer-admin'),
      headers: _headers(),
      body: json.encode(req.toJson()),
    );
    if (res.statusCode == 201) {
      return TransferAdminResponse.fromJson(json.decode(res.body) as Map<String, dynamic>);
    }
    throw ApiException('Error transferring admin', res.statusCode);
  }

  Future<InvitationResponse> createInvitation(String groupId, InvitationRequest req) async {
    final res = await _client.post(
      _uri('/api/groups/$groupId/invitations'),
      headers: _headers(),
      body: json.encode(req.toJson()),
    );
    if (res.statusCode == 201) {
      return InvitationResponse.fromJson(json.decode(res.body) as Map<String, dynamic>);
    }
    throw ApiException('Error creating invitation', res.statusCode);
  }

  Future<JoinResponse> joinGroup(JoinRequest req) async {
    final res = await _client.post(
      _uri('/api/groups/join'),
      headers: _headers(),
      body: json.encode(req.toJson()),
    );
    if (res.statusCode == 201) {
      return JoinResponse.fromJson(json.decode(res.body) as Map<String, dynamic>);
    }
    throw ApiException('Error joining group', res.statusCode);
  }

  Future<AssignedQuizResponse> assignQuiz(String groupId, AssignQuizRequest req) async {
    final res = await _client.post(
      _uri('/api/groups/$groupId/quizzes'),
      headers: _headers(),
      body: json.encode(req.toJson()),
    );
    if (res.statusCode == 201) {
      return AssignedQuizResponse.fromJson(json.decode(res.body) as Map<String, dynamic>);
    }
    throw ApiException('Error assigning quiz', res.statusCode);
  }

  Future<List<LeaderboardEntry>> getGroupLeaderboard(String groupId) async {
    final res = await _client.get(_uri('/api/groups/$groupId/leaderboard'), headers: _headers());
    if (res.statusCode == 200) {
      final List<dynamic> arr = json.decode(res.body) as List<dynamic>;
      return arr.map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw ApiException('Error getting leaderboard', res.statusCode);
  }

  Future<QuizLeaderboardResponse> getQuizLeaderboard(String groupId, String quizId) async {
    final res = await _client.get(_uri('/api/groups/$groupId/quizzes/$quizId/leaderboard'), headers: _headers());
    if (res.statusCode == 200) {
      return QuizLeaderboardResponse.fromJson(json.decode(res.body) as Map<String, dynamic>);
    }
    throw ApiException('Error getting quiz leaderboard', res.statusCode);
  }
}
