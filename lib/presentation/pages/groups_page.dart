import 'package:flutter/material.dart';

import '../../application/usecases/create_group_usecase.dart';
import '../../application/usecases/get_groups_usecase.dart';
import '../../application/usecases/join_group_usecase.dart';
import '../../application/usecases/get_leaderboard_usecase.dart';
import '../../domain/entities/group.dart';
import '../controllers/groups_controller.dart';
import 'group_detail_page.dart';

class GroupsPage extends StatefulWidget {
  final GetGroupsUseCase getGroupsUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final JoinGroupUseCase joinGroupUseCase;
  final GetGroupLeaderboardUseCase getLeaderboardUseCase;

  const GroupsPage({
    super.key,
    required this.getGroupsUseCase,
    required this.createGroupUseCase,
    required this.joinGroupUseCase,
    required this.getLeaderboardUseCase,
  });

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  late final GroupsController controller;

  @override
  void initState() {
    super.initState();
    controller = GroupsController(
      getGroupsUseCase: widget.getGroupsUseCase,
      createGroupUseCase: widget.createGroupUseCase,
      joinGroupUseCase: widget.joinGroupUseCase,
      getLeaderboardUseCase: widget.getLeaderboardUseCase,
    );
    controller.loadGroups();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _showCreateDialog() async {
    final nameCtrl = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear Grupo'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nombre del grupo'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(nameCtrl.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final created = await controller.createGroup(result);
      if (created != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
          const Icon(Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 8),
            Expanded(
            child: RichText(
              text: TextSpan(
              style: const TextStyle(color: Colors.white),
              children: <TextSpan>[
                const TextSpan(text: 'Grupo "'),
                TextSpan(
                  text: created.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: '" creado con éxito.'),
              ],
              ),
            ),
            ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            action: SnackBarAction(
              label: 'VER',
              textColor: Colors.white,
              onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => GroupDetailPage(
              group: created,
              getLeaderboardUseCase: widget.getLeaderboardUseCase,
            ),
          ));
              },
            ),
          ),
        );
        // Optionally navigate to detail
        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupDetailPage(group: created, getLeaderboardUseCase: widget.getLeaderboardUseCase)));
      } else {
        final err = controller.error ?? 'No se pudo crear el grupo';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $err')));
      }
    }
  }


  Future<void> _showJoinDialog() async {
    final tokenCtrl = TextEditingController();
    final token = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unirse por invitación'),
        content: TextField(
          controller: tokenCtrl,
          decoration: const InputDecoration(labelText: 'Token de invitación'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(tokenCtrl.text.trim()),
            child: const Text('Unirse'),
          ),
        ],
      ),
    );

    if (token != null && token.isNotEmpty) {
      final joined = await controller.joinWithToken(token);
      if (joined != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Te uniste al grupo "${joined.name}"')));
      } else {
        final err = controller.error ?? 'No se pudo unir al grupo';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $err')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Grupos')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.loading) return const Center(child: CircularProgressIndicator());
          if (controller.error != null) return Center(child: Text('Error: ${controller.error}'));
          if (controller.groups.isEmpty) return const Center(child: Text('No perteneces a ningún grupo'));

          return RefreshIndicator(
            onRefresh: controller.loadGroups,
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: controller.groups.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final Group g = controller.groups[index];
                return ListTile(
                  title: Text(g.name),
                  subtitle: Text('Miembros: ${g.memberCount} • Rol: ${g.role}'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GroupDetailPage(
                      group: g,
                      getLeaderboardUseCase: widget.getLeaderboardUseCase,
                    ),
                  )),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'create',
            onPressed: _showCreateDialog,
            tooltip: 'Crear grupo',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'join',
            onPressed: _showJoinDialog,
            tooltip: 'Unirse por invitación',
            child: const Icon(Icons.link),
          ),
        ],
      ),
    );
  }
}
