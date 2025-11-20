import 'package:flutter/material.dart';
import '../components/categories_grid.dart';
import '../components/search_bar.dart';
import '../components/quiz_card.dart';
import '../data/sample_quizzes.dart';
import '../data/sample_extra_content.dart';
import '../components/course_card.dart';
import '../components/creator_card.dart';
import '../components/hashtag_card.dart';
import 'hashtag_page.dart';


class CategoryDetailPage extends StatefulWidget {
  final CategoryItem category;
  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  String query = '';
  late List<Quiz> _all;

  @override
  void initState() {
    super.initState();
    _all = sampleQuizzes.where((q) => q.categories.contains(widget.category.name)).toList();
    _sort();
  }

  void _sort() {
    _all.sort((a, b) {
      final likesCmp = b.likes.compareTo(a.likes);
      if (likesCmp != 0) return likesCmp;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  List<Quiz> get _filtered {
    if (query.isEmpty) return _all;
    final lower = query.toLowerCase();
    return _all.where((q) => q.title.toLowerCase().contains(lower) || q.author.toLowerCase().contains(lower)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = _filtered;
    final relatedCategories = _relatedCategories();
    final courses = sampleCourses.where((c) => c.category == widget.category.name).toList();
    final creators = sampleCreators.where((cr) => cr.category == widget.category.name).toList();
    final hashtagGroups = sampleHashtags.where((h) => h.category == widget.category.name).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.category.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.category.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
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
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchBar(
                      onChanged: (s) => setState(() => query = s),
                      onFocusChanged: (_) {},
                      onClear: () => setState(() => query = ''),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _LanguageChip(),
                  const SizedBox(width: 8),
                  _CategoryChip(name: widget.category.name),
                ],
              ),
            ),
          ),

          _sectionTitle('Kahoots'),
          _buildQuizGrid(quizzes),
          if (quizzes.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Sin resultados para esta categoría'),
              ),
            ),

            if (query.isEmpty && courses.isNotEmpty) ...[
            _sectionHeaderWithAction('Kahoot!+ AccessPass', 'Ver todos', () {}),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) => CourseCard(course: courses[i]),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: courses.length,
                ),
              ),
            ),
          ],

          if (query.isEmpty && relatedCategories.isNotEmpty) ...[
            _sectionTitle('Categorías relacionadas'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 90,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) {
                    final cat = relatedCategories[i];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoryDetailPage(category: cat),
                          ),
                        );
                      },
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(image: NetworkImage(cat.imageUrl), fit: BoxFit.cover),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.65)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(cat.name, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: relatedCategories.length,
                ),
              ),
            ),
          ],

          if (query.isEmpty && hashtagGroups.isNotEmpty) ...[
            for (final group in hashtagGroups) ...[
              _sectionTitle('#${group.tag}'),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, i) {
                      final quiz = group.quizzes[i];
                      return SizedBox(
                        width: 160,
                        child: QuizCard(quiz: quiz),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: group.quizzes.length,
                  ),
                ),
              ),
            ],
          ],

          if (query.isEmpty) ...[
            _sectionTitle('Más juegos educativos'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) => _EducationalGameCard(index: i),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 3,
                ),
              ),
            ),
          ],

          if (query.isEmpty && creators.isNotEmpty) ...[
            _sectionTitle('Kahoot! Academy Verified Creators'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) => CreatorCard(creator: creators[i]),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: creators.length,
                ),
              ),
            ),
          ],

          if (query.isEmpty && hashtagGroups.isNotEmpty) ...[
            _sectionTitle('#${widget.category.name.toLowerCase()}'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) {
                    final group = hashtagGroups[i];
                    return HashtagCard(
                      group: group,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HashtagPage(group: group),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: hashtagGroups.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  SliverToBoxAdapter _sectionTitle(String title) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
      );

  SliverToBoxAdapter _sectionHeaderWithAction(String title, String action, VoidCallback onTap) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            TextButton(onPressed: onTap, child: Text(action))
          ],
        ),
      ),
    );
  }

  SliverPadding _buildQuizGrid(List<Quiz> quizzes) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final quiz = quizzes[index];
            return QuizCard(quiz: quiz);
          },
          childCount: quizzes.length,
        ),
      ),
    );
  }

  List<CategoryItem> _relatedCategories() {

    final allCats = <String>{};
    for (final q in sampleQuizzes) {
      allCats.addAll(q.categories);
    }
    final others = allCats.where((c) => c != widget.category.name).toList();

    final mapped = others.take(6).map((c) => CategoryItem(c, 'https://picsum.photos/seed/rel-$c/400/200')).toList();
    return mapped;
  }
}

class _LanguageChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.language, size: 18),
      label: const Text('Idioma'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String name;
  const _CategoryChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2)),
        ],
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Text(name.toLowerCase(), style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _EducationalGameCard extends StatelessWidget {
  final int index;
  const _EducationalGameCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = [
      [Colors.orange, Colors.red],
      [Colors.blueGrey, Colors.indigo],
      [Colors.deepPurple, Colors.purpleAccent],
    ];
    final gradient = colors[index % colors.length];
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              index == 0 ? 'Números' : index == 1 ? 'Descargar' : 'Big Math',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.18),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Descargar'),
            )
          ],
        ),
      ),
    );
  }
}