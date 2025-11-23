import 'package:flutter/material.dart';

import '../../domain/entities/group.dart';
import '../../domain/entities/leaderboard.dart';
import '../../application/usecases/get_leaderboard_usecase.dart';

class GroupDetailPage extends StatefulWidget {
  final Group group;
  final GetGroupLeaderboardUseCase getLeaderboardUseCase;

  const GroupDetailPage({super.key, required this.group, required this.getLeaderboardUseCase});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  bool loading = false;
  String? error;
  List<LeaderboardEntry> leaderboard = [];

  Future<void> _loadLeaderboard() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final list = await widget.getLeaderboardUseCase(widget.group.id);
      leaderboard = list;
    } catch (e) {
      error = e.toString();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // load leaderboard lazily
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${widget.group.id}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Miembros: ${widget.group.memberCount}'),
            const SizedBox(height: 8),
            Text('Rol: ${widget.group.role}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLeaderboard,
              child: const Text('Ver leaderboard'),
            ),
            const SizedBox(height: 8),
            if (loading) const CircularProgressIndicator(),
            if (error != null) Text('Error: $error'),
            if (!loading && leaderboard.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: leaderboard.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final e = leaderboard[index];
                    return ListTile(
                      title: Text(e.name),
                      subtitle: Text('Quizzes completados: ${e.completedQuizzes} • Puntos: ${e.totalPoints}'),
                      trailing: Text('#${e.position}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
