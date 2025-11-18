import 'package:flutter/material.dart';

import '../infrastructure/challenge_api.dart';
import '../application/services/challenge_service.dart';
import '../domain/entidades/challenge_models.dart';
import '../presentation/screens/challenge_list_screen.dart';
import '../presentation/screens/personal_results_screen.dart';
import '../presentation/screens/ranking_screen.dart';

void main() {
  runApp(const ApplicationSimulation());
}

class ApplicationSimulation extends StatelessWidget {
  const ApplicationSimulation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChallengeListScreen(),
      routes: {
        '/results': (_) => const PersonalResultsScreen(),
        '/ranking': (_) => const RankingScreen(),
      },
    );
  }
}

class SimulationHomePage extends StatelessWidget {
  const SimulationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Home Page'),
      ),
      body: const Center(
        child: Text('This is a simulation for the application layer.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example usage of the ChallengeService (wraps the API client).
          final api = ChallengeApi(baseUrl: 'https://api.example.com');
          final service = ChallengeService(api);
          try {
            final req = CreateChallengeRequest(kahootId: '00000000-0000-0000-0000-000000000000');
            final res = await service.createChallenge(req);
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Challenge created'),
                  content: Text('PIN: ${res.challengePin}\nShare: ${res.shareLink}'),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]),
              );
            }
          }
        },
        child: const Icon(Icons.api),
      ),
    );
  }
}
