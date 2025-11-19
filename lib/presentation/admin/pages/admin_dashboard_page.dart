import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/admin/widgets/admin_drawer.dart';
import 'package:flutter_application_1/presentation/admin/controllers/metrics_controller.dart';
import 'package:flutter_application_1/domain/entities/role.dart';
import 'package:flutter_application_1/presentation/admin/services/admin_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

int _maxOf(List<int> vals) {
  if (vals.isEmpty) return 1;
  final m = vals.reduce((a, b) => a > b ? a : b);
  return m > 0 ? m : 1;
}

String _formatDateIso(String? iso) {
  if (iso == null) return '';
  try {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy $hh:$min:$ss';
  } catch (_) {
    return iso;
  }
}

class _HorizontalBar extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  const _HorizontalBar({Key? key, required this.label, required this.value, required this.max, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pct = (max > 0) ? (value / max) : 0.0;
    final displayPct = (pct * 100).clamp(0, 100).toStringAsFixed(0);
    return LayoutBuilder(builder: (context, constraints) {
      final barWidth = constraints.maxWidth * pct;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text('$value (${displayPct}%)')]),
        const SizedBox(height: 6),
        Container(
            width: constraints.maxWidth,
            height: 18,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(6)),
            child: Stack(children: [
              Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    width: barWidth,
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                  ))]),
        ),
      ]);
    });
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({Key? key, required this.color, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label)
    ]);
  }
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late final MetricsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MetricsController(service: AdminService(baseUrl: 'http://localhost:3000'));
    _controller.addListener(() => setState(() {}));
    _controller.loadMetrics();
  }

  @override
  void dispose() {
    // no-op: simple app; controller will be GC'd
    super.dispose();
  }

  Widget _card(String title, Widget child) => Card(
        child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), child])),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Admin'), actions: [
        IconButton(icon: const Icon(Icons.home), onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst)),
        IconButton(
            tooltip: 'Poblar datos de demo',
            icon: const Icon(Icons.cloud_download),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text('Poblar datos de demo'),
                        content: const Text('Esto reemplazará los datos actuales en el servidor mock. ¿Continuar?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Poblar'))
                        ],
                      ));
              if (confirm == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Poblando datos...')));
                final res = await _controller.seedAndReload();
                if (res != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seed completado: kahoots=${res['kahoots']}, users=${res['users']}, authors=${res['authors']}')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${_controller.error}')));
                }
              }
            }),
      ]),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _controller.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Métricas globales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // Legend for role colors
                  Row(children: [
                    _LegendItem(color: Colors.teal, label: Role.student.label),
                    const SizedBox(width: 12),
                    _LegendItem(color: Colors.orange, label: Role.teacher.label),
                  ]),
                  const SizedBox(height: 12),
                  // top row cards with simple bar charts (animated entrance)
                  AnimatedOpacity(
                    opacity: _controller.loading ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 360),
                    curve: Curves.easeInOut,
                    child: AnimatedSlide(
                      offset: _controller.loading ? const Offset(0, 0.02) : Offset.zero,
                      duration: const Duration(milliseconds: 360),
                      child: Row(children: [
                        Expanded(
                            child: _card(
                                'Kahoots',
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Total: ${_controller.kahootsTotal}'),
                                  const SizedBox(height: 8),
                                  _HorizontalBar(label: 'Kahoots', value: _controller.kahootsTotal, max: _maxOf([_controller.kahootsTotal, _controller.usersTotal, _controller.authorsTotal]), color: Colors.blue),
                                  const SizedBox(height: 8),
                                  const Text('Temas principales:'),
                                  const SizedBox(height: 6),
                                  // show top topics
                                  if (_controller.topTopics.isEmpty) const Text('- (sin datos)')
                                  else ..._controller.topTopics.map((t) => Padding(padding: const EdgeInsets.only(bottom: 6.0), child: _HorizontalBar(label: t['topic']?.toString() ?? 'Tema', value: (t['count'] is int) ? t['count'] as int : int.tryParse(t['count']?.toString() ?? '0') ?? 0, max: _maxOf([_controller.kahootsTotal, ..._controller.topicsCounts.values]), color: Colors.indigo))),
                                  const SizedBox(height: 6),
                                  const Text('Recientes:'),
                                  ..._controller.recentKahoots.map((k) => Text('- ${k['title']} (${_formatDateIso(k['createdAt']?.toString())})'))
                                ]))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _card(
                                'Usuarios',
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Total: ${_controller.usersTotal}'),
                                  const SizedBox(height: 8),
                                  // Active vs Blocked bars
                                  _HorizontalBar(label: 'Activos', value: _controller.usersActive, max: _controller.usersTotal > 0 ? _controller.usersTotal : 1, color: Colors.green),
                                  const SizedBox(height: 6),
                                  _HorizontalBar(label: 'Bloqueados', value: _controller.usersBlocked, max: _controller.usersTotal > 0 ? _controller.usersTotal : 1, color: Colors.red),
                                  const SizedBox(height: 8),
                                  const Text('Por rol:'),
                                  const SizedBox(height: 6),
                                  // role breakdown bars
                                  if (_controller.usersByRoleCounts.isEmpty) const Text('- (sin datos)')
                                  else ..._controller.usersByRoleCounts.entries.map((e) {
                                    final role = e.key;
                                    final cnt = e.value;
                                    final pct = (_controller.usersByRolePercent[role] ?? 0.0).toStringAsFixed(1);
                                    final roleLabel = RoleExt.fromString(role).label;
                                    return Padding(padding: const EdgeInsets.only(bottom: 6.0), child: _HorizontalBar(label: '$roleLabel (${pct}%)', value: cnt, max: _controller.usersTotal > 0 ? _controller.usersTotal : 1, color: role == 'teacher' ? Colors.orange : Colors.teal));
                                  }),
                                  const SizedBox(height: 8),
                                  const Text('Recientes:'),
                                  ..._controller.recentUsers.map((u) {
                                    final roleStr = (u['role'] ?? u['userType'] ?? 'student').toString();
                                    final roleLabel = RoleExt.fromString(roleStr).label;
                                    final status = (u['status'] ?? '').toString();
                                    return Text('- ${u['name']} (${roleLabel} • ${status})');
                                  })
                                ]))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _card(
                                'Autores',
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Total: ${_controller.authorsTotal}'),
                                  const SizedBox(height: 8),
                                  _HorizontalBar(label: 'Autores', value: _controller.authorsTotal, max: _maxOf([_controller.kahootsTotal, _controller.usersTotal, _controller.authorsTotal]), color: Colors.orange),
                                  const SizedBox(height: 8),
                                  const Text('Recientes:'),
                                  ..._controller.recentAuthors.map((a) => Text('- ${a['name']}'))
                                ]))),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_controller.error != null) Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('Error: ${_controller.error}', style: const TextStyle(color: Colors.red))),
                ],
              ),
      ),
    );
  }
}
