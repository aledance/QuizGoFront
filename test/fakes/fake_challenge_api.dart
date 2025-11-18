import 'dart:async';

import 'package:flutter_application_1/infrastructure/challenge_api.dart';
import 'package:flutter_application_1/domain/entidades/challenge_models.dart';
import 'package:flutter_application_1/domain/entidades/player_models.dart';
import 'package:flutter_application_1/domain/entidades/response_models.dart';
import 'package:flutter_application_1/domain/entidades/ranking_models.dart';

/// A very small fake ChallengeApi for unit tests. Implements the same public
/// surface as the real client used by `ChallengeService`.
class FakeChallengeApi implements ChallengeApi {
  final String baseUrl;

  FakeChallengeApi({this.baseUrl = 'https://fake'});

  @override
  Future<CreateChallengeResponse> createChallenge(CreateChallengeRequest req) async {
    return CreateChallengeResponse(challengeId: 'fake-ch-1', challengePin: 123456, shareLink: 'https://share');
  }

  @override
  Future<RegisterPlayerResponse> registerPlayer(String challengeId, RegisterPlayerRequest req) async {
    if (req.nickname == 'bad') {
      throw BadRequestException('invalid nickname');
    }
    return RegisterPlayerResponse(playerId: 'player-1', playerToken: 'token-abc');
  }

  @override
  Future<SubmitResponseResult> submitResponse(String challengeId, SubmitResponseRequest req, String playerToken) async {
    if (playerToken != 'token-abc') throw UnauthorizedException('invalid token');
    return SubmitResponseResult(status: 'OK', isCorrect: true, pointsEarned: 10, currentScore: 10);
  }

  @override
  Future<List<RankingEntry>> getRanking(String challengeId) async {
    return [RankingEntry(nickname: 'alice', totalScore: 100, timeAvgMs: 500.0, rank: 1)];
  }

  // The real ChallengeApi has no other public members to implement.
}
