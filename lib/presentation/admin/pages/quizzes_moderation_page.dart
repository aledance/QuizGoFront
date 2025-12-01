import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/presentation/admin/widgets/admin_drawer.dart';
import 'package:flutter_application_1/infrastructure/datasources/kahoot_remote_data_source.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/presentation/pages/kahoot_editor_page.dart';

class QuizzesModerationPage extends StatefulWidget {
  const QuizzesModerationPage({super.key});

  @override
  State<QuizzesModerationPage> createState() => _QuizzesModerationPageState();
}

class _QuizzesModerationPageState extends State<QuizzesModerationPage> {
  late final KahootRemoteDataSource _dataSource;
  late Future<List<Map<String, dynamic>>> _futureList;
  static const _adminToken = 'admin_token';

  @override
  void initState() {
    super.initState();
    _dataSource = KahootRemoteDataSource(client: http.Client(), baseUrl: apiBaseUrl);
    _futureList = _dataSource.listKahoots();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureList = _dataSource.listKahoots();
    });
    await _futureList;
  }

  Future<void> _toggleActive(Map<String, dynamic> kahoot) async {
    final id = kahoot['id']?.toString();
    if (id == null) return;
    final currentlyActive = (kahoot['active'] ?? true) == true;
    await _dataSource.patchKahoot(id, {'active': !currentlyActive}, authToken: _adminToken);
    await _refresh();
  }

  Future<void> _deleteKahoot(Map<String, dynamic> kahoot) async {
    final id = kahoot['id']?.toString();
    if (id == null) return;
    await _dataSource.deleteKahoot(id, authToken: _adminToken);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Kahoots!')),
      drawer: const AdminDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureList,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snap.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _refresh, child: const Text('Reintentar')),
                ],
              ),
            );
          }
          final list = snap.data ?? <Map<String, dynamic>>[];
          if (list.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [SizedBox(height: 200), Center(child: Text('No hay kahoots'))],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final k = list[index];
                final title = k['title'] ?? k['name'] ?? 'Untitled';
                final author = (k['author'] is Map) ? (k['author']['name'] ?? k['author']['authorId'] ?? '') : '';
                final topic = k['topic'] ?? '';
                final active = (k['active'] ?? true) == true;
                return ListTile(
                  title: Text(title.toString()),
                  subtitle: Text('$author • $topic'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final id = k['id']?.toString();
                          if (id == null) return;


                          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => KahootEditorPage(kahootId: id)));
                          await _refresh();
                        },
                      ),

                      IconButton(
                        icon: Icon(active ? Icons.block : Icons.refresh, color: active ? Colors.orange : Colors.green),
                        tooltip: active ? 'Bloquear' : 'Activar',
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.maybeOf(context);
                          final isBlocking = active;
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              title: Text(isBlocking ? 'Bloquear kahoot' : 'Activar kahoot'),
                              content: Text(isBlocking ? '¿Estás seguro que quieres bloquear este kahoot?' : '¿Estás seguro que quieres activar este kahoot?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(dCtx).pop(false), child: const Text('Cancelar')),
                                TextButton(onPressed: () => Navigator.of(dCtx).pop(true), child: Text(isBlocking ? 'Bloquear' : 'Activar')),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          try {
                            await _toggleActive(k);
                            messenger?.showSnackBar(SnackBar(content: Text(isBlocking ? 'Kahoot bloqueado' : 'Kahoot activado')));
                          } catch (e) {
                            messenger?.showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
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
                                title: const Text('Eliminar kahoot'),
                                content: const Text('¿Estás seguro que quieres eliminar este kahoot? Esta acción no se puede deshacer.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(dCtx).pop(false), child: const Text('Cancelar')),
                                  TextButton(onPressed: () => Navigator.of(dCtx).pop(true), child: const Text('Eliminar')),
                                ],
                              ),
                            );
                            if (confirmed != true) return;
                            try {
                              await _deleteKahoot(k);
                              messenger?.showSnackBar(const SnackBar(content: Text('Kahoot eliminado')));
                            } catch (e) {
                              messenger?.showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}