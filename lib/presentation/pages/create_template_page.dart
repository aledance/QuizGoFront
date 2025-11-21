import 'package:flutter/material.dart';

import 'kahoot_editor_page.dart';

class CreateTemplatePage extends StatelessWidget {
  const CreateTemplatePage({super.key});

  void _openEditor(BuildContext context, {String? templateId}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const KahootEditorPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear kahoot'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => _openEditor(context),
            child: const Text('Saltar', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Text('Selecciona una plantilla', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Empieza rápido eligiendo un estilo o crea desde cero en cualquier momento.', style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  const _FeaturedTemplate(),
                  const SizedBox(height: 24),
                  Text('Plantillas populares', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final template = _templates[index];
                  return _TemplateCard(
                    option: template,
                    onTap: () => _openEditor(context, templateId: template.id),
                  );
                },
                childCount: _templates.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _openEditor(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Crear un kahoot en blanco'),
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateOption {
  final String id;
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  const _TemplateOption({required this.id, required this.title, required this.description, required this.color, required this.icon});
}

const _templates = [
  _TemplateOption(id: 'quiz', title: 'Trivia clásico', description: 'Preguntas de opción múltiple', color: Color(0xFF5B00D4), icon: Icons.quiz_outlined),
  _TemplateOption(id: 'truefalse', title: 'Verdadero/Falso', description: 'Dos opciones rápidas', color: Color(0xFF008B99), icon: Icons.check_circle_outline),
  _TemplateOption(id: 'puzzle', title: 'Rompecabezas', description: 'Ordena las respuestas', color: Color(0xFFDC5C05), icon: Icons.extension_outlined),
  _TemplateOption(id: 'poll', title: 'Encuesta', description: 'Conoce las opiniones', color: Color(0xFF00A885), icon: Icons.bar_chart_outlined),
];

class _TemplateCard extends StatelessWidget {
  final _TemplateOption option;
  final VoidCallback onTap;
  const _TemplateCard({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [option.color.withValues(alpha: 0.85), option.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: option.color.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 10)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
              child: Icon(option.icon, color: Colors.white),
            ),
            const Spacer(),
            Text(option.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(option.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _FeaturedTemplate extends StatelessWidget {
  const _FeaturedTemplate();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [scheme.secondaryContainer, scheme.primary.withValues(alpha: 0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crear con plantillas premium', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Explora colecciones exclusivas y ahorra tiempo con diseños listos.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KahootEditorPage())),
                  child: const Text('Explorar plantillas'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.star_border, size: 48, color: Colors.white),
        ],
      ),
    );
  }
}