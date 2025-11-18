import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_challenge_api.dart';
import 'package:flutter_application_1/application/token_storage_in_memory.dart';
import 'package:flutter_application_1/application/services/challenge_service.dart';
import 'package:flutter_application_1/domain/entidades/challenge_models.dart';
import 'package:flutter_application_1/domain/entidades/player_models.dart';
import 'package:flutter_application_1/domain/entidades/response_models.dart';

void main() {
  group('ChallengeService', () {
    late FakeChallengeApi api;
    late InMemoryTokenStorage storage;
    late ChallengeService service;

    setUp(() {
      api = FakeChallengeApi();
      storage = InMemoryTokenStorage();
      service = ChallengeService(api, tokenStorage: storage);
    });

    test('createChallenge returns response', () async {
      final req = CreateChallengeRequest(kahootId: 'kahoot-1');
      final res = await service.createChallenge(req);
      expect(res.challengeId, 'fake-ch-1');
    });

    test('registerPlayer persists token', () async {
      final req = RegisterPlayerRequest(nickname: 'alice', challengePin: 123456);
      final res = await service.registerPlayer('fake-ch-1', req);
      expect(res.playerToken, 'token-abc');

      final stored = await storage.readToken('playerToken:${res.playerId}');
      expect(stored, 'token-abc');
    });

    test('submitResponse maps unauthorized to AuthError', () async {
      final req = SubmitResponseRequest(slideIndex: 0, answerIndex: 1, timeElapsedMs: 1000);
      await expectLater(() => service.submitResponse('fake-ch-1', req, 'bad-token'), throwsA(isA<Exception>()));
    });
  });
}
