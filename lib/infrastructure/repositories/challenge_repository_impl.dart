import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../datasources/challenge_remote_data_source.dart';
// DTO imports not required here (data conversion happens in remote/data source)

class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengeRemoteDataSource remote;

  ChallengeRepositoryImpl({required this.remote});

  @override
  Future<Challenge> createChallenge(Map<String, dynamic> data) async {
    final dto = await remote.createChallenge(data);
    return dto.toEntity();
  }

  @override
  Future<Map<String, dynamic>> registerPlayer(String challengeId, Map<String, dynamic> data) async {
    final dto = await remote.registerPlayer(challengeId, data);
    return {'playerId': dto.playerId, 'playerToken': dto.playerToken};
  }

  @override
  Future<Map<String, dynamic>> submitResponse(String challengeId, Map<String, dynamic> data, {required String playerToken}) async {
    return await remote.submitResponse(challengeId, data, playerToken: playerToken);
  }

  @override
  Future<List<Map<String, dynamic>>> getRanking(String challengeId) async {
    final list = await remote.getRanking(challengeId);
    return list.map((r) => r.toJson()).toList();
  }
}
