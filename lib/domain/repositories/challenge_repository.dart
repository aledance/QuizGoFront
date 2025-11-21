import '../entities/challenge.dart';

abstract class ChallengeRepository {
  Future<Challenge> createChallenge(Map<String, dynamic> data);

  Future<Map<String, dynamic>> registerPlayer(String challengeId, Map<String, dynamic> data);

  Future<Map<String, dynamic>> submitResponse(String challengeId, Map<String, dynamic> data, {required String playerToken});

  Future<List<Map<String, dynamic>>> getRanking(String challengeId);
}
