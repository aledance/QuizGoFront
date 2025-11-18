import 'package:flutter/material.dart';

class PersonalResultsScreen extends StatelessWidget {
  const PersonalResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample personal results
    final items = [
      {'title': 'Reto 1', 'score': 120},
      {'title': 'Reto 2', 'score': 80},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados personales')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final it = items[i];
          return Card(
            child: ListTile(
              title: Text(it['title'] as String),
              trailing: Text('${it['score']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
