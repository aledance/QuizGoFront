import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/admin/pages/admin_dashboard_page.dart';
import 'package:flutter_application_1/presentation/admin/pages/users_page.dart';
import 'package:flutter_application_1/presentation/admin/pages/quizzes_moderation_page.dart';
import 'package:flutter_application_1/presentation/admin/pages/themes_page.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('Admin Panel')),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminDashboardPage())),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Usuarios'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UsersPage())),
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Moderación de quices'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizzesModerationPage())),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Temas'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ThemesPage())),
          ),
        ],
      ),
    );
  }
}
