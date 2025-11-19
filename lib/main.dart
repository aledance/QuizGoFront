import 'package:flutter/material.dart';

import 'presentation/screens/challenge_list_screen.dart';
import 'presentation/screens/personal_results_screen.dart';
import 'presentation/screens/ranking_screen.dart';

void main() {
  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    // App entry: UI uses sample data for now.

    return MaterialApp(
      title: 'QuizGo - Demo UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const ChallengeListScreen(),
      routes: {
        '/results': (_) => const PersonalResultsScreen(),
        '/ranking': (_) => const RankingScreen(),
      },
    );
  }
}
