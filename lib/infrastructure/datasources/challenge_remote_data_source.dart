import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

import '../dtos/challenge_dto.dart';
import '../dtos/player_dto.dart';
import '../dtos/ranking_item_dto.dart';

class ChallengeRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ChallengeRemoteDataSource({required this.client, String? baseUrl})
      : baseUrl = baseUrl ?? (Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000');

  Future<ChallengeDto> createChallenge(Map<String, dynamic> data, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/challenges');
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null && authToken.isNotEmpty) headers['Authorization'] = 'Bearer $authToken';
    final res = await client.post(uri, headers: headers, body: jsonEncode(data)).timeout(const Duration(seconds: 10));
    if (res.statusCode == 201) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return ChallengeDto.fromJson(body);
    }
    throw Exception('Failed to create challenge: ${res.statusCode} ${res.body}');
  }

  Future<PlayerDto> registerPlayer(String challengeId, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/challenges/$challengeId/players');
    final res = await client.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(data)).timeout(const Duration(seconds: 10));
    if (res.statusCode == 201) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return PlayerDto.fromJson(body);
    }
    throw Exception('Failed to register player: ${res.statusCode} ${res.body}');
  }

  Future<Map<String, dynamic>> submitResponse(String challengeId, Map<String, dynamic> data, {required String playerToken}) async {
    final uri = Uri.parse('$baseUrl/challenges/$challengeId/responses');
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $playerToken'};
    final res = await client.post(uri, headers: headers, body: jsonEncode(data)).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to submit response: ${res.statusCode} ${res.body}');
  }

  Future<List<RankingItemDto>> getRanking(String challengeId) async {
    final uri = Uri.parse('$baseUrl/challenges/$challengeId/ranking');
    final res = await client.get(uri, headers: {'Accept': 'application/json'}).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as List<dynamic>;
      return body.map((e) => RankingItemDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to get ranking: ${res.statusCode} ${res.body}');
  }
}
