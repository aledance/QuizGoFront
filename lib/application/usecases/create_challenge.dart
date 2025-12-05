import '../../domain/repositories/challenge_repository.dart';

class CreateChallenge {
  final ChallengeRepository repository;

  CreateChallenge(this.repository);

  Future<Map<String, dynamic>> call(Map<String, dynamic> data) async {
    final challenge = await repository.createChallenge(data);
    return {
      'challengeId': challenge.id,
      'challengePin': challenge.challengePin,
      'shareLink': challenge.shareLink,
    };
  }
}
