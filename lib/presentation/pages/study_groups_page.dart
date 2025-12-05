import 'package:flutter/material.dart';
import '../data/sample_quizzes.dart';

class StudyGroupsPage extends StatelessWidget {
  final List<Map<String, dynamic>> groups;
  const StudyGroupsPage({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus grupos de estudio'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: groups.isEmpty
          ? Center(child: Text('No estás unido a ningún grupo aún', style: Theme.of(context).textTheme.bodyLarge))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: groups.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final g = groups[index];
                final name = (g['name'] ?? 'Sin nombre').toString();
                final members = (g['members'] ?? 0) as int;
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.primary.withOpacity(0.12)),
                      child: const Icon(Icons.group, size: 28),
                    ),
                    title: Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text('$members miembros'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudyGroupDetailPage(group: g))),
                  ),
                );
              },
            ),
    );
  }
}

class StudyGroupDetailPage extends StatefulWidget {
  final Map<String, dynamic> group;
  const StudyGroupDetailPage({super.key, required this.group});

  @override
  State<StudyGroupDetailPage> createState() => _StudyGroupDetailPageState();
}

class _StudyGroupDetailPageState extends State<StudyGroupDetailPage> {
  late final String name;
  late int membersCount;
  late List<Map<String, String>> members;
  late List<Map<String, dynamic>> messages;

  @override
  void initState() {
    super.initState();
    final g = widget.group;
    name = (g['name'] ?? 'Sin nombre').toString();
    membersCount = (g['members'] ?? 0) as int;

    // Generate members list if not provided
    final rawMembers = g['membersList'];
    if (rawMembers is List && rawMembers.isNotEmpty) {
      members = rawMembers.map<Map<String, String>>((m) {
        if (m is String) return {'name': m, 'avatar': ''};
        if (m is Map) return {'name': m['name']?.toString() ?? 'Usuario', 'avatar': m['avatar']?.toString() ?? ''};
        return {'name': 'Usuario', 'avatar': ''};
      }).toList();
    } else {
      final count = membersCount > 0 ? membersCount.clamp(1, 12) : 3;
      members = List.generate(count, (i) => {'name': 'Usuario ${i + 1}', 'avatar': ''});
    }

    // Generate recent messages if not provided
    final rawMessages = g['messages'];
    if (rawMessages is List && rawMessages.isNotEmpty) {
      messages = rawMessages.map<Map<String, dynamic>>((m) {
        if (m is Map) return {'from': m['from']?.toString() ?? 'Usuario', 'text': m['text']?.toString() ?? '', 'date': DateTime.tryParse(m['date']?.toString() ?? '') ?? DateTime.now()};
        return {'from': 'Usuario', 'text': m.toString(), 'date': DateTime.now()};
      }).toList();
    } else {
      messages = List.generate(4, (i) => {'from': members[i % members.length]['name']!, 'text': 'Mensaje de ejemplo ${i + 1}', 'date': DateTime.now().subtract(Duration(minutes: (i + 1) * 7))});
    }
  }

  String _formatTime(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  void _openInviteSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Invitar grupo "$name" a un quiz', style: Theme.of(context).textTheme.titleMedium),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: sampleQuizzes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx2, idx) {
                  final q = sampleQuizzes[idx];
                  return ListTile(
                    title: Text(q.title),
                    subtitle: Text(q.author),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invitación enviada: ${q.title} → $name')));
                      },
                      child: const Text('Invitar'),
                    ),
                  );
                },
              ),
            )
          ]),
        );
      },
    );
  }

  void _openAddMemberDialog() {
    final ctrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Invitar usuario', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(hintText: 'Nombre o email del usuario'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar'))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final text = ctrl.text.trim();
                          if (text.isEmpty) return;
                          setState(() {
                            members.add({'name': text, 'avatar': ''});
                            membersCount = membersCount + 1;
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invitación enviada a $text')));
                        },
                        child: const Text('Invitar'),
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final description = widget.group['description']?.toString() ?? 'No hay descripción disponible.';
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 72, height: 72, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.group, size: 36)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: Theme.of(context).textTheme.titleLarge), Text('$membersCount miembros')]),
          ]),
          const SizedBox(height: 20),
          Text('Descripción', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 16),
          Text('Miembros', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: members.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                if (i == members.length) {
                  // Add user button
                  return Column(children: [
                    GestureDetector(
                      onTap: _openAddMemberDialog,
                      child: CircleAvatar(radius: 28, backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12), child: const Icon(Icons.add)),
                    ),
                    const SizedBox(height: 6),
                    const SizedBox(width: 72, child: Text('Agregar', overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)),
                  ]);
                }
                final m = members[i];
                final initials = (m['name'] ?? '').split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join();
                return Column(children: [
                  CircleAvatar(radius: 28, child: Text(initials)),
                  const SizedBox(height: 6),
                  SizedBox(width: 72, child: Text(m['name'] ?? '', overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)),
                ]);
              },
            ),
          ),
          const SizedBox(height: 16),
          Text('Últimos mensajes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final msg = messages[i];
                final from = msg['from']?.toString() ?? 'Usuario';
                final text = msg['text']?.toString() ?? '';
                final date = msg['date'] is DateTime ? msg['date'] as DateTime : DateTime.now();
                return ListTile(
                  leading: CircleAvatar(child: Text(from.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join())),
                  title: Text(from, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(_formatTime(date)),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Volver'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(onPressed: _openInviteSheet, child: const Text('Invitar grupo al quiz'))),
          ])
        ]),
      ),
    );
  }
}
