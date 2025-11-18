import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ranking = [
      {'nick': 'alice', 'score': 120, 'time': 450},
      {'nick': 'bob', 'score': 100, 'time': 500},
      {'nick': 'carlos', 'score': 80, 'time': 800},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Ranking del reto')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: ranking.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final r = ranking[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(r['nick'] as String),
              subtitle: Text('Tiempo medio: ${r['time']} ms'),
              trailing: Text('${r['score']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
