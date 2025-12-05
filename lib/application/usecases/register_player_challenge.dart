import '../../domain/repositories/challenge_repository.dart';

class RegisterPlayerChallenge {
  final ChallengeRepository repository;

  RegisterPlayerChallenge(this.repository);

  Future<Map<String, dynamic>> call(String challengeId, Map<String, dynamic> data) async {
    return await repository.registerPlayer(challengeId, data);
  }
}
