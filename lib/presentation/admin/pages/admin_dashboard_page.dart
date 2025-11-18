import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/admin/widgets/admin_drawer.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Admin'), actions: [
        IconButton(icon: const Icon(Icons.home), onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst)),
      ]),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Métricas globales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            // Placeholders for charts
            Card(child: SizedBox(height: 150, child: Center(child: Text('Gráfico: usuarios activos')))),
            SizedBox(height: 12),
            Card(child: SizedBox(height: 150, child: Center(child: Text('Gráfico: quices creados')))),
          ],
        ),
      ),
    );
  }
}
