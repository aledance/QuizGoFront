import 'package:flutter/material.dart';
import '../components/categories_grid.dart';
import '../components/channel_cards_carousel.dart';
import '../data/categories_data.dart';
import 'kahoot_editor_page.dart';
import 'session_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onCreateTap;
  const HomePage({super.key, this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categories = kDefaultCategories;
    final createHandler = onCreateTap ?? () {
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SessionPage()),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: scheme.primary.withValues(alpha: 0.15),
                  child: const Text('T'),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, Team Morado',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00A88C), padding: const EdgeInsets.symmetric(horizontal: 20)),
                child: const Text('Actualizar'),
              ),
              const SizedBox(width: 12),
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
            ],
          ),
        ),
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
                  _QuickCard(onCreateTap: createHandler),
                  const SizedBox(height: 24),
                  _CategorySlider(items: categories),
                  const SizedBox(height: 24),
                  _StudyGroupsSection(groups: _mockStudyGroups),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Explora más formas de jugar'),
                  _PurplePromo(onPressed: () {}),
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

class _StudyGroup {
  final String name;
  final int members;
  const _StudyGroup({required this.name, required this.members});
}

const _mockStudyGroups = [
  _StudyGroup(name: 'Grupo de Ciencias', members: 12),
  _StudyGroup(name: 'Historia Universal', members: 18),
];

class _StudyGroupsSection extends StatelessWidget {
  final List<_StudyGroup> groups;
  const _StudyGroupsSection({required this.groups});

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
                onPressed: () {},
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
                return _NewGroupCard(onTap: () {});
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
  final _StudyGroup group;
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
              Text('${group.members} miembros', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          Text(group.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () {},
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