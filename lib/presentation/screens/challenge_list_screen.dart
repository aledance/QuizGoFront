import 'package:flutter/material.dart';

import '../../domain/entidades/challenge_models.dart';
import '../widgets/challenge_card.dart';
import 'challenge_detail_screen.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  // Sample data for UI; in real app this comes from ChallengeService
  List<CreateChallengeResponse> _sampleChallenges() => [
        CreateChallengeResponse(challengeId: '1', challengePin: 123456, shareLink: 'https://share/1'),
        CreateChallengeResponse(challengeId: '2', challengePin: 654321, shareLink: 'https://share/2'),
      ];

  @override
  Widget build(BuildContext context) {
    final challenges = _sampleChallenges();

    return Scaffold(
      appBar: AppBar(title: const Text('Desafíos activos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final ch = challenges[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChallengeDetailScreen(challengeId: ch.challengeId))),
              child: ChallengeCard(
                challengeId: ch.challengeId,
                pin: ch.challengePin,
                deadline: DateTime.now().add(Duration(days: index + 1)),
                shareLink: ch.shareLink,
              ),
            ),
          );
        },
      ),
    );
  }
}
