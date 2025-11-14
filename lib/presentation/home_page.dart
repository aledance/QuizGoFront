import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/quiz/quiz_editor_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuizGoFront')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.create),
                label: const Text('Crear / Editar Quiz'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizEditorPage())),
                style: ElevatedButton.styleFrom(minimumSize: const Size(220, 48)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
