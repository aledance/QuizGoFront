import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/admin/widgets/admin_drawer.dart';

class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de temas')),
      drawer: const AdminDrawer(),
      body: const Center(child: Text('Gestión de temas (próximamente)')),
    );
  }
}
