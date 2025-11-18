import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/entities/role.dart';
import 'package:flutter_application_1/presentation/admin/widgets/admin_drawer.dart';
import 'package:flutter_application_1/presentation/admin/controllers/users_controller.dart';
import 'package:flutter_application_1/presentation/admin/services/admin_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final UsersController _controller;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _controller = UsersController(service: AdminService(baseUrl: 'http://localhost:3000'));
    _controller.addListener(() => setState(() {}));
    _controller.loadUsers();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // no-op: controller listener removed by GC in this simple scaffold
    super.dispose();
  }

  void _showCreateDialog() {
    final nameC = TextEditingController();
    final emailC = TextEditingController();
  // allow selecting a single role when creating; if none chosen default to player
  Role? selectedRole;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear usuario'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: emailC, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            const Align(alignment: Alignment.centerLeft, child: Text('Roles (opcional)', style: TextStyle(fontWeight: FontWeight.bold))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: Role.values.map((r) {
                return RadioListTile<Role>(
                  title: Text(r.value),
                  value: r,
                  groupValue: selectedRole,
                  onChanged: (v) {
                    selectedRole = v;
                    (ctx as Element).markNeedsBuild();
                  },
                );
              }).toList(),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nameC.text.trim().isEmpty || emailC.text.trim().isEmpty) return;
              final id = DateTime.now().millisecondsSinceEpoch.toString();
              final roleToUse = selectedRole ?? Role.player;
              final u = User(id: id, name: nameC.text, email: emailC.text, role: roleToUse);
              _controller.addUser(u);
              Navigator.of(ctx).pop();
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de usuarios'), actions: [
        IconButton(icon: const Icon(Icons.home), onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst)),
      ]),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Row(children: [
            Expanded(child: TextField(
              controller: _searchController,
              decoration: InputDecoration(hintText: 'Buscar por nombre o email', suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () { _controller.setSearch(_searchController.text); _controller.loadUsers(); })),
              onSubmitted: (v) { _controller.setSearch(v); _controller.loadUsers(); },
            )),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _controller.roleFilter,
              hint: const Text('Filtrar por rol'),
              items: [
                const DropdownMenuItem<String>(value: '', child: Text('Todos')),
                ...Role.values.map((r) => DropdownMenuItem<String>(value: r.value, child: Text(r.value))).toList(),
              ],
              onChanged: (v) {
                final val = (v != null && v.isEmpty) ? null : v;
                _controller.setRoleFilter(val);
                _controller.loadUsers();
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _showCreateDialog, child: const Text('Crear usuario'))
          ]),
          const SizedBox(height: 12),
          if (_controller.error != null) Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Container(width: double.infinity, color: Colors.red[50], padding: const EdgeInsets.all(8.0), child: Text(_controller.error!, style: const TextStyle(color: Colors.red)))),
          Expanded(
            child: _controller.loading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    Expanded(child: ListView.builder(
                      itemCount: _controller.users.length,
                      itemBuilder: (context, index) {
                      final u = _controller.users[index];
                      return Card(
                        child: ListTile(
                          title: Text(u.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.email),
                              const SizedBox(height: 4),
                              Wrap(children: [Chip(label: Text(u.role.value))]),
                            ],
                          ),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () async {
                              final nameC = TextEditingController(text: u.name);
                              final emailC = TextEditingController(text: u.email);
                              final messenger = ScaffoldMessenger.maybeOf(context);
                              Role? selectedRole = u.role;
                              final updated = await showDialog<User?>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Editar usuario'),
                                  content: SingleChildScrollView(
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                      TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nombre')),
                                      TextField(controller: emailC, decoration: const InputDecoration(labelText: 'Email')),
                                      const SizedBox(height: 8),
                                      const Align(alignment: Alignment.centerLeft, child: Text('Roles', style: TextStyle(fontWeight: FontWeight.bold))),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: Role.values.map((r) {
                                          return RadioListTile<Role>(
                                            title: Text(r.value),
                                            value: r,
                                            groupValue: selectedRole,
                                            onChanged: (v) {
                                              selectedRole = v;
                                              (ctx as Element).markNeedsBuild();
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ]),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancelar')),
                                    ElevatedButton(onPressed: () {
                                      final id = u.id;
                                      final newU = User(id: id, name: nameC.text, email: emailC.text, active: u.active, role: selectedRole ?? Role.player, createdAt: u.createdAt);
                                      Navigator.of(ctx).pop(newU);
                                    }, child: const Text('Guardar')),
                                  ],
                                ),
                              );
                              if (updated == null) return;
                              _controller.updateUser(updated.id, updated);
                              messenger?.showSnackBar(const SnackBar(content: Text('Usuario actualizado')));
                            }),
                            IconButton(
                              icon: Icon(u.active ? Icons.block : Icons.check),
                              onPressed: () async {
                                final messenger = ScaffoldMessenger.maybeOf(context);
                                final isBlocking = u.active; // if active -> action is block
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (dCtx) => AlertDialog(
                                    title: Text(isBlocking ? 'Bloquear usuario' : 'Activar usuario'),
                                    content: Text(isBlocking ? '¿Estás seguro que quieres bloquear este usuario?' : '¿Estás seguro que quieres activar este usuario?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.of(dCtx).pop(false), child: const Text('Cancelar')),
                                      TextButton(onPressed: () => Navigator.of(dCtx).pop(true), child: Text(isBlocking ? 'Bloquear' : 'Activar')),
                                    ],
                                  ),
                                );
                                if (confirmed != true) return;
                                await _controller.blockUser(u.id, block: isBlocking);
                                messenger?.showSnackBar(SnackBar(content: Text(isBlocking ? 'Usuario bloqueado' : 'Usuario activado')));
                              },
                            ),
                            Builder(builder: (ctx) {
                              return IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.maybeOf(ctx);
                                    final confirmed = await showDialog<bool>(
                                      context: ctx,
                                      builder: (dCtx) => AlertDialog(
                                        title: const Text('Eliminar usuario'),
                                        content: const Text('¿Estás seguro que quieres eliminar este usuario?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.of(dCtx).pop(false), child: const Text('Cancelar')),
                                          TextButton(onPressed: () => Navigator.of(dCtx).pop(true), child: const Text('Eliminar')),
                                        ],
                                      ),
                                    );
                                    if (confirmed != true) return;
                                    _controller.removeUser(u.id);
                                    messenger?.showSnackBar(const SnackBar(content: Text('Usuario eliminado')));
                                  });
                            }),
                          ]),
                        ),
                      );
                      },
                    )),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextButton(onPressed: () { _controller.prevPage(); _controller.loadUsers(); }, child: const Text('Anterior')),
                      const SizedBox(width: 12),
                      Text('Página ${_controller.page}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      TextButton(onPressed: () { _controller.nextPage(); _controller.loadUsers(); }, child: const Text('Siguiente')),
                    ])
                  ]),
          ),
        ]),
      ),
    );
  }
}
