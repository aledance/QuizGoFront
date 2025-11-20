import 'package:flutter/material.dart';
import '../admin/pages/admin_dashboard_page.dart';
import '../components/course_card.dart';
import '../components/hashtag_card.dart';
import '../components/quiz_card.dart';
import '../data/partner_collections.dart';
import '../data/sample_extra_content.dart';

class PartnerCollectionPage extends StatelessWidget {
  final PartnerCollection collection;
  const PartnerCollectionPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final quizzes = collectionQuizzes(collection, limit: 12);
    final courses = collectionCourses(collection);
    final hashtags = sampleHashtags
        .where((h) => collection.hashtags.contains(h.tag) || collection.categories.contains(h.category))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                  ),
                  icon: const Icon(Icons.dashboard_customize_outlined, size: 18),
                  label: const Text('Backoffice'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(collection.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(collection.imageUrl, fit: BoxFit.cover),
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
                  Text(collection.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: collection.categories
                        .map((c) => Chip(
                              label: Text(c),
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          if (courses.isNotEmpty) ...[
            _sectionHeader('Cursos destacados', context, action: TextButton(
              onPressed: () {},
              child: const Text('Ver todos'),
            )),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) => CourseCard(
                    course: courses[i],
                    onTap: () => Navigator.of(context).pushNamed('/curso/${courses[i].id}', arguments: courses[i]),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: courses.length,
                ),
              ),
            ),
          ],
          if (quizzes.isNotEmpty) ...[
            _sectionHeader('Kahoots de la colección', context),
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
                  (ctx, index) => QuizCard(quiz: quizzes[index]),
                  childCount: quizzes.length,
                ),
              ),
            ),
          ],
          if (hashtags.isNotEmpty) ...[
            _sectionHeader('Hashtags recomendados', context),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) {
                    final group = hashtags[i];
                    return HashtagCard(
                      group: group,
                      onTap: () {
                        final slug = hashtagSlug(group.tag);
                        Navigator.of(context).pushNamed('/hashtag/$slug', arguments: group);
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: hashtags.length,
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  SliverToBoxAdapter _sectionHeader(String title, BuildContext context, {Widget? action}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            if (action != null) action,
          ],
        ),
      ),
    );
  }
}