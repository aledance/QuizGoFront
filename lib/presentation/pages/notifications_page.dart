import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  bool read;

  NotificationItem({required this.id, required this.title, required this.body, required this.date, this.read = false});
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _items = [
    NotificationItem(id: '1', title: 'Bienvenido a QuizGo', body: 'Gracias por unirte. Explora kahoots y crea el tuyo.', date: DateTime.now().subtract(const Duration(hours: 3)), read: true),
    NotificationItem(id: '2', title: 'Nuevo curso asignado', body: 'Se te asignó el curso "Historia Universal".', date: DateTime.now().subtract(const Duration(days: 1)), read: false),
    NotificationItem(id: '3', title: 'Recordatorio', body: 'Tu quiz empieza en 2 horas.', date: DateTime.now().subtract(const Duration(days: 2)), read: false),
  ];

  void _markAllRead() {
    setState(() {
      for (var it in _items) {
        it.read = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Todas las notificaciones marcadas como leídas')));
  }

  void _sendGeneralNotification() {
    final item = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Notificación general',
      body: 'Hay novedades importantes en la aplicación. Revisa ahora.',
      date: DateTime.now(),
      read: false,
    );
    setState(() {
      _items.insert(0, item);
    });
  }

  final Map<String, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        title: const Text('Notificaciones'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                _markAllRead();
              } else if (value == 2) {
                _sendGeneralNotification();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text('Marcar todos como leídos')),
              const PopupMenuItem(value: 2, child: Text('Enviar notificación general (demo)')),
            ],
          ),
        ],
      ),
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: _items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Este es el espacio donde aparecerán las notificaciones sobre grupos de estudio, seguidores y demás.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final n = _items[index];
                  final isExpanded = _expanded[n.id] ?? false;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          n.read = true;
                          _expanded[n.id] = !(isExpanded);
                        });
                      },
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: scheme.onSurface.withOpacity(0.04)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // unread dot
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(top: 6, right: 12),
                                    decoration: BoxDecoration(
                                      color: n.read ? Colors.transparent : scheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(n.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                            ),
                                            Text(_formatDate(n.date), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          // show a short preview when collapsed
                                          isExpanded ? n.body : (n.body.length > 80 ? '${n.body.substring(0, 80)}…' : n.body),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // expanded full content
                              if (isExpanded) ...[
                                const SizedBox(height: 12),
                                Text(n.body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                                const SizedBox(height: 8),
                                // optional actions when expanded
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() => _expanded[n.id] = false);
                                      },
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
