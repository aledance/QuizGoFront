import '../../domain/repositories/challenge_repository.dart';

class GetChallengeRanking {
  final ChallengeRepository repository;

  GetChallengeRanking(this.repository);

  Future<List<Map<String, dynamic>>> call(String challengeId) async {
    return await repository.getRanking(challengeId);
  }
}
