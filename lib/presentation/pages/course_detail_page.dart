import 'package:flutter/material.dart';
import '../data/sample_extra_content.dart';
import '../data/sample_quizzes.dart';
import '../components/quiz_card.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  String _priceLabel() {
    if (course.accessPass) return 'Incluido en AccessPass';
    if (course.priceCents == null) return 'Gratis';
    final amount = course.priceCents! / 100;
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final relatedQuizzes = sampleQuizzes.where((quiz) => quiz.categories.contains(course.category)).take(6).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(course.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(course.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categoría: ${course.category}', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                  Text(
                    'Incluye ${course.activities} actividades guiadas para reforzar ${course.category.toLowerCase()}.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(course.accessPass ? Icons.workspace_premium : Icons.shopping_bag_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_priceLabel(), style: Theme.of(context).textTheme.titleMedium),
                              Text('Accede a todos los materiales listos para usar.'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Iniciar'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Contenido del curso', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...List.generate(
                    course.activities,
                    (index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Actividad ${index + 1}'),
                      subtitle: const Text('Recurso interactivo listo para usar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (relatedQuizzes.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text('Kahoots relacionados', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) => QuizCard(quiz: relatedQuizzes[index]),
                  childCount: relatedQuizzes.length,
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}