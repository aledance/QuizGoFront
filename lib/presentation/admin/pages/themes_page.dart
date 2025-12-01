import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/presentation/admin/widgets/admin_drawer.dart';
import 'package:flutter_application_1/infrastructure/datasources/theme_remote_data_source.dart';
import 'package:flutter_application_1/config.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  late final ThemeRemoteDataSource _dataSource;
  late Future<List<Map<String, dynamic>>> _future;
  static const _adminToken = 'admin_token';

  @override
  void initState() {
    super.initState();
    _dataSource = ThemeRemoteDataSource(client: http.Client(), baseUrl: API_BASE_URL);
    _future = _dataSource.listThemes();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _dataSource.listThemes();
    });
    await _future;
  }

  Future<void> _createTheme() async {
    final nameC = TextEditingController();
    final created = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear tema'),
        content: TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop({'name': nameC.text}), child: const Text('Crear')),
        ],
      ),
    );
    if (created == null) return;
    try {
      await _dataSource.createTheme({'name': created['name']}, authToken: _adminToken);
      await _refresh();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tema creado')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _editTheme(Map<String, dynamic> theme) async {
    final nameC = TextEditingController(text: theme['name']?.toString() ?? '');
    final updated = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar tema'),
        content: TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop({'name': nameC.text}), child: const Text('Guardar')),
        ],
      ),
    );
    if (updated == null) return;
    try {
      await _dataSource.patchTheme(theme['id'].toString(), {'name': updated['name']}, authToken: _adminToken);
      await _refresh();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tema actualizado')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteTheme(Map<String, dynamic> theme) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tema'),
        content: Text('¿Seguro que quieres eliminar "${theme['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _dataSource.deleteTheme(theme['id'].toString(), authToken: _adminToken);
      await _refresh();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tema eliminado')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de temas')),
      drawer: const AdminDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final list = snap.data ?? <Map<String, dynamic>>[];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Temas (${list.length})', style: const TextStyle(fontWeight: FontWeight.bold)), ElevatedButton(onPressed: _createTheme, child: const Text('Crear tema'))]),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final t = list[index];
                    return ListTile(
                      title: Text(t['name']?.toString() ?? 'Sin nombre'),
                      subtitle: Text('ID: ${t['id']}'),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _editTheme(t)),
                        IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteTheme(t)),
                      ]),
                    );
                  },
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}