import 'package:http/http.dart' as http;

import '../../infrastructure/datasources/challenge_remote_data_source.dart';
import '../../infrastructure/repositories/challenge_repository_impl.dart';
import '../../application/usecases/create_challenge.dart';
import '../../application/usecases/register_player_challenge.dart';
import '../../application/usecases/submit_challenge_response.dart';
import '../../application/usecases/get_challenge_ranking.dart';

class ChallengeService {
  final CreateChallenge createChallengeUC;
  final RegisterPlayerChallenge registerPlayerUC;
  final SubmitChallengeResponse submitResponseUC;
  final GetChallengeRanking getRankingUC;

  ChallengeService._(this.createChallengeUC, this.registerPlayerUC, this.submitResponseUC, this.getRankingUC);

  factory ChallengeService({String? baseUrl}) {
    final client = http.Client();
    final remote = ChallengeRemoteDataSource(client: client, baseUrl: baseUrl);
    final repo = ChallengeRepositoryImpl(remote: remote);
    return ChallengeService._(
      CreateChallenge(repo),
      RegisterPlayerChallenge(repo),
      SubmitChallengeResponse(repo),
      GetChallengeRanking(repo),
    );
  }
}
