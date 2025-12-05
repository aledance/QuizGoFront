import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/infrastructure/dtos/session_report_dto.dart';
import '../components/categories_grid.dart';
import '../components/channel_cards_carousel.dart';
import '../data/categories_data.dart';
import '../data/api_simulation.dart';
import 'kahoot_editor_page.dart';
import 'kahoot_challenge_prototype.dart';
import 'session_page.dart';
import 'notifications_page.dart';
import 'create_study_group_page.dart';
import 'study_groups_page.dart';
import 'groups_page.dart';

// Infrastructure + usecases imports to create a quick wiring point from Home
import '../../infrastructure/repositories/simulated_group_repository.dart';
import '../../application/usecases/get_groups_usecase.dart';
import '../../application/usecases/create_group_usecase.dart';
import '../../application/usecases/join_group_usecase.dart';
import '../../application/usecases/get_leaderboard_usecase.dart';

/// Página principal de la aplicación (Dashboard).
/// Muestra un resumen de la actividad del usuario, grupos, categorías y acceso rápido a crear contenido.
class HomePage extends StatefulWidget {
  final VoidCallback? onCreateTap;
  const HomePage({super.key, this.onCreateTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Simulación de API para datos de demostración
  final _api = ApiSimulation();
  
  // Estado local para grupos y categorías
  List<Map<String, dynamic>> _userGroups = [];
  List<CategoryItem> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Carga los datos iniciales (grupos y categorías) simulando una petición de red.
  Future<void> _loadData() async {
    try {
      final groups = await _api.getUserGroups();
      final categories = await _api.getCategories();
      if (mounted) {
        setState(() {
          _userGroups = groups;
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

// Presentation: challenge UI removed — revert to previous behavior (no service calls here)

  Future<void> _handleCreateGroup() async {
    final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateStudyGroupPage()));
    if (res != null && res is Map<String, dynamic>) {
      setState(() {
        _userGroups.insert(0, res);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Grupo "${res['name']}" creado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final categories = _categories;
    final createHandler = widget.onCreateTap ?? () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const KahootEditorPage()),
      );
    };
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: scheme.surface,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SessionPage()),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: scheme.primary.withAlpha(38),
                  child: const Text('T'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, Team Morado',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // IconButton(
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
              //   },
              //   icon: const Icon(Icons.refresh),
              // ),
            ],
          ),
        ),
        actions: [
            Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              IconButton(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
                },
                icon: const Icon(Icons.notifications_none),
              ),
              ],
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Tus kahoots'),
                  const SizedBox(height: 12),
                  // Demo: Reports panel (H10) - shows session report ranking and question analysis
                  const _ReportsDemoSection(),
                  _QuickCard(onCreateTap: createHandler),
                  const SizedBox(height: 24),
                  _CategorySlider(items: categories),
                  const SizedBox(height: 24),
                  _StudyGroupsSection(groups: _userGroups, onCreate: _handleCreateGroup),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Explora más formas de jugar'),
                  _PurplePromo(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KahootChallengePrototype()))),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: ChannelCardsCarousel()),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _QuickCard({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.celebration, color: Theme.of(context).colorScheme.primary, size: 36),
          ),
          Text(
            '¡Que empiecen los juegos!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onCreateTap,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32)),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}

class _PurplePromo extends StatelessWidget {
  final VoidCallback onPressed;
  const _PurplePromo({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Color(0xFF4B00B4), Color(0xFF8A2BFF)]),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 16,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4B00B4),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text('¡Empecemos!'),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Text(
              'Explorar más\nformas de jugar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _StudyGroupsSection extends StatelessWidget {
  final List<Map<String, dynamic>> groups;
  final Future<void> Function()? onCreate;
  const _StudyGroupsSection({required this.groups, this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Text('Grupos de estudio', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navegar a la interfaz completa de Grupos (usa el repo simulado).
                  final repo = SimulatedGroupRepository();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupsPage(
                        getGroupsUseCase: GetGroupsUseCase(repo),
                        createGroupUseCase: CreateGroupUseCase(repo),
                        joinGroupUseCase: JoinGroupUseCase(repo),
                        getLeaderboardUseCase: GetGroupLeaderboardUseCase(repo),
                      )));
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
            child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _NewGroupCard(onTap: () {
                  if (onCreate != null) {
                    onCreate!();
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateStudyGroupPage()));
                  }
                });
              }
              final group = groups[index - 1];
              return _StudyGroupCard(group: group);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: groups.length + 1,
          ),
        ),
      ],
    );
  }
}

class _NewGroupCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewGroupCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: scheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              Text('+ Nuevo grupo', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyGroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  const _StudyGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: scheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: scheme.primary),
              const SizedBox(width: 8),
              Text('${group['members']} miembros', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          Text(group['name'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () {
              final membersCount = (group['members'] is int) ? group['members'] as int : int.tryParse(group['members']?.toString() ?? '1') ?? 1;
              final membersList = List.generate(membersCount.clamp(1, 12), (i) => 'Usuario ${i + 1}');
              final messages = List.generate(4, (i) => {'from': membersList[i % membersList.length], 'text': 'Mensaje ${i + 1} de ejemplo', 'date': DateTime.now().subtract(Duration(minutes: (i + 1) * 6)).toIso8601String()});
              final map = {
                'name': group['name'],
                'members': membersCount,
                'description': group['description'] ?? 'Grupo de estudio sobre ${group['name']}',
                'membersList': group['membersList'] ?? membersList,
                'messages': group['messages'] ?? messages
              };
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudyGroupDetailPage(group: map)));
            },
            child: const Text('Ver grupo'),
          ),
        ],
      ),
    );
  }
}

class _CategorySlider extends StatelessWidget {
  final List<CategoryItem> items;
  const _CategorySlider({required this.items});

  void _openCategory(BuildContext context, CategoryItem item) {
    final slug = slugifyCategory(item.name);
    Navigator.of(context).pushNamed('/categoria/$slug', arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Categorías'),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final item = items[index];
              return _CategorySlideCard(
                item: item,
                onTap: () => _openCategory(context, item),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}

class _ReportsDemoSection extends StatefulWidget {
  const _ReportsDemoSection({Key? key}) : super(key: key);

  @override
  State<_ReportsDemoSection> createState() => _ReportsDemoSectionState();
}

class _ReportsDemoSectionState extends State<_ReportsDemoSection> {
  bool _loading = false;
  String? _error;
  SessionReportDto? _report;

  // For demo purposes use a placeholder baseUrl. Replace with your API base URL.
  // final ReportsService _service = ReportsService.create(baseUrl: 'https://api.example.com');

  Future<void> _loadReport() async {
    setState(() {
      _loading = true;
      _error = null;
      _report = null;
    });
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return simulated data directly
      setState(() {
        _report = SessionReportDto(
          reportId: 'local-demo',
          sessionId: 'local-session',
          title: 'Demo: informe local',
          executionDate: DateTime.now(),
          playerRanking: List.generate(8, (i) => PlayerRankingDto(position: i + 1, username: 'Jugador ${i + 1}', score: (9000 - i * 500), correctAnswers: 8 - (i % 3))),
          questionAnalysis: List.generate(6, (i) => QuestionAnalysisDto(questionIndex: i, questionText: 'Pregunta de ejemplo ${i + 1}', correctPercentage: 0.6 - (i * 0.05).clamp(0.0, 1.0))),
        );
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Informe de sesión (demo)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  // allow the button to shrink if space is constrained
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: FilledButton(
                      onPressed: _loading ? null : _loadReport,
                      child: const Text('Cargar informe', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_loading) const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Error: ${_error}',
                    style: TextStyle(color: scheme.error),
                    softWrap: true,
                  ),
                ),
              if (_report != null) ...[
                const SizedBox(height: 8),
                Text('Título: ' + _report!.title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Text('Fecha: ' + _report!.executionDate.toLocal().toString(), style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                Text('Ranking de jugadores', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(_report!.playerRanking.length > 5 ? 5 : _report!.playerRanking.length, (index) {
                    final p = _report!.playerRanking[index];
                    return Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(child: Text('${p.position}')),
                            const SizedBox(width: 12),
                            Expanded(child: Text(p.username, softWrap: true, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 12),
                            Text('${p.score} pts'),
                          ],
                        ),
                        if (index != (_report!.playerRanking.length > 5 ? 4 : _report!.playerRanking.length - 1)) const Divider(height: 8),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text('Análisis por pregunta', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_report!.questionAnalysis.length > 5 ? 5 : _report!.questionAnalysis.length, (index) {
                    final q = _report!.questionAnalysis[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pregunta ${q.questionIndex + 1}: ' + q.questionText, style: Theme.of(context).textTheme.bodyMedium, softWrap: true, overflow: TextOverflow.visible),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(value: q.correctPercentage, color: scheme.primary, backgroundColor: scheme.surfaceVariant),
                          const SizedBox(height: 4),
                          Text('Correctas: ${(q.correctPercentage * 100).toStringAsFixed(0)}%')
                        ],
                      ),
                    );
                  }),
                ),
                if ((_report!.playerRanking.length > 5) || (_report!.questionAnalysis.length > 5))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Mostrando los primeros 5 ítems. Actualiza para ver más.', style: Theme.of(context).textTheme.bodySmall),
                  ),
              ]
            ],
          ),
    );
  }
}

class _CategorySlideCard extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback onTap;
  const _CategorySlideCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 18, offset: const Offset(0, 10)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(item.imageUrl, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.15), Colors.black.withValues(alpha: 0.75)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.arrow_forward, color: scheme.secondary, size: 18),
                        const SizedBox(width: 6),
                        Text('Ver más', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}