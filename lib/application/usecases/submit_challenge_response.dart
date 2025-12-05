import '../../domain/repositories/challenge_repository.dart';

class SubmitChallengeResponse {
  final ChallengeRepository repository;

  SubmitChallengeResponse(this.repository);

  Future<Map<String, dynamic>> call(String challengeId, Map<String, dynamic> data, {required String playerToken}) async {
    return await repository.submitResponse(challengeId, data, playerToken: playerToken);
  }
}
