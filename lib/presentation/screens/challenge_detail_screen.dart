import 'package:flutter/material.dart';

import '../../domain/entidades/challenge_models.dart';
import '../widgets/progress_bar.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeId;
  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  int _currentIndex = 0;

  // sample question set
  final _questions = const [
    {'text': 'Pregunta 1', 'options': ['A', 'B', 'C', 'D']},
    {'text': 'Pregunta 2', 'options': ['A', 'B', 'C', 'D']},
    {'text': 'Pregunta 3', 'options': ['A', 'B', 'C', 'D']},
  ];

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;

    return Scaffold(
      appBar: AppBar(title: Text('Reto ${widget.challengeId}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressLinear(value: (_currentIndex + 1) / total),
            const SizedBox(height: 16),
            Text('Pregunta ${_currentIndex + 1} de $total', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(_questions[_currentIndex]['text'] as String, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ...(((_questions[_currentIndex]['options'] as List<String>) ).map((o) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(onPressed: () => _onAnswer(0), child: Text(o)),
                ))),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: _currentIndex > 0 ? _prev : null, child: const Text('Anterior')),
                ElevatedButton(onPressed: _currentIndex < total - 1 ? _next : _finish, child: Text(_currentIndex < total - 1 ? 'Siguiente' : 'Finalizar')),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onAnswer(int index) {
    // In real app send response to service; here just move to next
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _finish();
    }
  }

  void _next() => setState(() => _currentIndex++);
  void _prev() => setState(() => _currentIndex--);

  void _finish() {
    Navigator.pushReplacementNamed(context, '/results');
  }
}
