import 'package:flutter/material.dart';
import '../data/sample_quizzes.dart';
import '../services/challenge_service.dart';

class QuizDetailPage extends StatelessWidget {
  final Quiz quiz;
  const QuizDetailPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kahoot'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
              child: Image.network(quiz.imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quiz.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [Text(quiz.author, style: Theme.of(context).textTheme.bodySmall), const Spacer(), Text('${quiz.likes} ♥')]),
                  const SizedBox(height: 16),
                  Text('Descripción', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Categorías: ${quiz.categories.join(', ')}', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Creado: ${quiz.createdAt.toLocal().toString().split('.').first}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 20),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Iniciar Kahoot'))),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Simple local flow to create a challenge for this kahoot using ChallengeService
                        final service = await _createService();
                        try {
                          final res = await service.createChallengeUC.call({'kahootId': quiz.id});
                          final pin = res['challengePin'];
                          final link = res['shareLink'];
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: const Text('Reto creado'),
                                    content: Text('PIN: $pin\nCompartir: $link'),
                                    actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))],
                                  ));
                        } catch (e) {
                          showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))]));
                        }
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Crear Reto Asíncrono'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ChallengeService> _createService() async {
    // Factory is synchronous but kept async for future DI changes
    return ChallengeService();
  }
}
