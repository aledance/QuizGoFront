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

    final gradient = LinearGradient(colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with Kahoot-like purple gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 48, bottom: 20, left: 16, right: 16),
            decoration: BoxDecoration(gradient: gradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Desafíos activos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('¡Únete a un reto o crea uno nuevo!', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
          ),
        ],
      ),
    );
  }
}
