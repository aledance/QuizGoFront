import '../../infrastructure/challenge_api.dart';
import '../../domain/entidades/challenge_models.dart';
import '../../domain/entidades/player_models.dart';
import '../../domain/entidades/response_models.dart';
import '../../domain/entidades/ranking_models.dart';
import '../errors.dart';
import '../token_storage.dart';


/// Application-level service that orchestrates challenge use-cases.
/// Keeps orchestration out of UI and infrastructure.
class ChallengeService {
  final ChallengeApi api;
  final TokenStorage? tokenStorage;

  /// [tokenStorage] is optional; if provided the service will persist
  /// player tokens after successful registration.
  ChallengeService(this.api, {this.tokenStorage});

  /// Create a challenge. Validates expirationDate locally before calling infra.
  Future<CreateChallengeResponse> createChallenge(CreateChallengeRequest req) async {
    if (req.expirationDate != null && req.expirationDate!.isBefore(DateTime.now())) {
      throw ValidationError('Expiration date must be in the future');
    }

    try {
      return await api.createChallenge(req);
    } on BadRequestException catch (e) {
      throw ValidationError(e.toString());
    } on NotFoundException catch (e) {
      throw NotFoundError(e.toString());
    } on ApiException catch (e) {
      throw ApiError(e.body, statusCode: e.statusCode);
    }
  }

  /// Register a player in a challenge using the PIN and nickname.
  Future<RegisterPlayerResponse> registerPlayer(String challengeId, RegisterPlayerRequest req) async {
    try {
      final res = await api.registerPlayer(challengeId, req);
      // Persist playerToken if tokenStorage is available.
      if (tokenStorage != null && res.playerToken.isNotEmpty) {
        await tokenStorage!.saveToken('playerToken:${res.playerId}', res.playerToken);
      }
      return res;
    } on BadRequestException catch (e) {
      throw ValidationError(e.toString());
    } on NotFoundException catch (e) {
      throw NotFoundError(e.toString());
    } on ApiException catch (e) {
      throw ApiError(e.body, statusCode: e.statusCode);
    }
  }

  /// Submit or update an answer for a player in a challenge.
  Future<SubmitResponseResult> submitResponse(String challengeId, SubmitResponseRequest req, String playerToken) async {
    if (playerToken.isEmpty) throw AuthError('playerToken cannot be empty');

    try {
      return await api.submitResponse(challengeId, req, playerToken);
    } on BadRequestException catch (e) {
      throw ValidationError(e.toString());
    } on UnauthorizedException catch (e) {
      throw AuthError(e.toString());
    } on NotFoundException catch (e) {
      throw NotFoundError(e.toString());
    } on ApiException catch (e) {
      throw ApiError(e.body, statusCode: e.statusCode);
    }
  }

  /// Retrieve the current ranking for the challenge.
  Future<List<RankingEntry>> getRanking(String challengeId) async {
    try {
      return await api.getRanking(challengeId);
    } on NotFoundException catch (e) {
      throw NotFoundError(e.toString());
    } on ApiException catch (e) {
      throw ApiError(e.body, statusCode: e.statusCode);
    }
  }
}
