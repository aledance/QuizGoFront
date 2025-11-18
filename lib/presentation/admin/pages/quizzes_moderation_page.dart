import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/admin/widgets/admin_drawer.dart';

class QuizzesModerationPage extends StatelessWidget {
  const QuizzesModerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moderación de quices')),
      drawer: const AdminDrawer(),
      body: const Center(child: Text('Listado de quices para moderar (próximamente)')),
    );
  }
}
