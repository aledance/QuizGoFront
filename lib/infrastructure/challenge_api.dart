import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/challenge_models.dart';
import '../domain/player_models.dart';
import '../domain/response_models.dart';
import '../domain/ranking_models.dart';

/// A lightweight client for the Challenge-related API endpoints described in
/// the spec. All requests / responses use camelCase JSON.
class ChallengeApi {
  final String baseUrl;
  final http.Client _client;

  ChallengeApi({required this.baseUrl, http.Client? client}) : _client = client ?? http.Client();

  Uri _url(String path) => Uri.parse(baseUrl + path);

  Future<CreateChallengeResponse> createChallenge(CreateChallengeRequest req) async {
    final uri = _url('/challenges');
    final body = jsonEncode(req.toJson());
    final res = await _client.post(uri, headers: {'Content-Type': 'application/json'}, body: body);

    if (res.statusCode == 201) {
      return CreateChallengeResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }

    _handleError(res);
    throw Exception('Unexpected error');
  }

  Future<RegisterPlayerResponse> registerPlayer(String challengeId, RegisterPlayerRequest req) async {
    final uri = _url('/challenges/$challengeId/players');
    final res = await _client.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(req.toJson()));

    if (res.statusCode == 201) {
      return RegisterPlayerResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }

    _handleError(res);
    throw Exception('Unexpected error');
  }

  Future<SubmitResponseResult> submitResponse(String challengeId, SubmitResponseRequest req, String playerToken) async {
    final uri = _url('/challenges/$challengeId/responses');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $playerToken',
    };

    final res = await _client.post(uri, headers: headers, body: jsonEncode(req.toJson()));

    if (res.statusCode == 200) {
      return SubmitResponseResult.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }

    _handleError(res);
    throw Exception('Unexpected error');
  }

  Future<List<RankingEntry>> getRanking(String challengeId) async {
    final uri = _url('/challenges/$challengeId/ranking');
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as List<dynamic>;
      return body.map((e) => RankingEntry.fromJson(e as Map<String, dynamic>)).toList();
    }

    _handleError(res);
    throw Exception('Unexpected error');
  }

  void _handleError(http.Response res) {
    switch (res.statusCode) {
      case 400:
        throw BadRequestException(res.body);
      case 401:
        throw UnauthorizedException(res.body);
      case 404:
        throw NotFoundException(res.body);
      default:
        throw ApiException(res.statusCode, res.body);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);
  @override
  String toString() => 'ApiException($statusCode): $body';
}

class BadRequestException extends ApiException {
  BadRequestException(String body) : super(400, body);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String body) : super(401, body);
}

class NotFoundException extends ApiException {
  NotFoundException(String body) : super(404, body);
}
