import 'package:flutter/material.dart';
import 'settings_page.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Inicia sesión para más'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crea y guarda kahoots, y accede a más funciones con una cuenta de Kahoot!.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Iniciar sesión'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Registrarse'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _ProfileBubble(label: 'Tú', icon: Icons.person),
                const SizedBox(width: 12),
                _ProfileBubble(label: 'Añadir niño', icon: Icons.child_care),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {},
                )
              ],
            ),
            const SizedBox(height: 24),
            _PromoCard(onTap: () {}),
            const SizedBox(height: 16),
            const Center(child: _PageIndicator(count: 5, index: 0)),
            const SizedBox(height: 24),
            _StatsRow(stats: const ['Siguiendo', 'Seguidores', 'Creado']),
            const SizedBox(height: 24),
            _SessionListTile(title: 'Tu plan y funciones', icon: Icons.auto_awesome_outlined),
            _SessionListTile(title: 'Tu contenido comprado', icon: Icons.shopping_cart_outlined),
            _SessionListTile(title: 'Tus personajes', icon: Icons.emoji_emotions_outlined, trailing: const Text('34')),
            _SessionListTile(title: 'Personalización', icon: Icons.palette_outlined),
          ],
        ),
      ),
    );
  }
}

class _ProfileBubble extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ProfileBubble({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: scheme.surfaceContainer,
          child: Icon(icon, size: 32, color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  final VoidCallback onTap;
  const _PromoCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF07070F), Color(0xFF3D006A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diviértete con amigos y familia gracias a Kahoot!+ Gold',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.timer_outlined, color: Colors.white70),
                SizedBox(width: 6),
                Text('4 días 23:47:47', style: TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Más información'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int index;
  const _PageIndicator({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return Container(
          width: active ? 16 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<String> stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerLow,
      ),
      child: Row(
        children: stats.map((label) {
          return Expanded(
            child: Column(
              children: [
                Text('0', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(label, style: theme.textTheme.bodySmall),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SessionListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _SessionListTile({required this.title, required this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}