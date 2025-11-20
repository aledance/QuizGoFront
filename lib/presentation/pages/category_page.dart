import 'package:flutter/material.dart';
import '../components/search_bar.dart';
import '../components/quiz_card.dart';
import '../data/sample_quizzes.dart';
import '../components/categories_grid.dart';
import '../data/sample_extra_content.dart';
import '../components/course_card.dart';
import '../components/creator_card.dart';
import '../components/hashtag_card.dart';
import 'hashtag_page.dart';

class CategoryPage extends StatefulWidget {
  final CategoryItem category;
  final String? initialQuery;
  const CategoryPage({super.key, required this.category, this.initialQuery});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String query = '';
  late List<Quiz> _all;

  @override
  void initState() {
    super.initState();
    _all = sampleQuizzes.where((q) => q.categories.contains(widget.category.name)).toList();
    _sort();
    if (widget.initialQuery != null) {
      query = widget.initialQuery!;
    }
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
            child: Column(
              children: [
                AppSearchBar(
                  onChanged: (s) => setState(() => query = s),
                  onFocusChanged: (_) {},
                  onClear: () => setState(() => query = ''),
                ),
              ],
            ),
          ),
          if (query.isEmpty) ...[
            _buildCoursesSection(),
            _buildCreatorsSection(),
            _buildHashtagsSection(),
          ],
          _buildQuizGrid(quizzes),
          if (quizzes.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Sin resultados para esta categoría'),
              ),
            ),
        ],
      ),
    );
  }

  SliverPadding _buildQuizGrid(List<Quiz> quizzes) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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

  SliverToBoxAdapter _sectionTitle(String title) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
      );

  Widget _horizontalScroll(List<Widget> children, {double height = 160}) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) => children[i],
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: children.length,
      ),
    );
  }

  SliverToBoxAdapter _buildCoursesSection() {
    final courses = sampleCourses.where((c) => c.category == widget.category.name).toList();
    if (courses.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Cursos'),
          _horizontalScroll(courses.map((c) => CourseCard(course: c)).toList(), height: 180),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildCreatorsSection() {
    final creators = sampleCreators.where((cr) => cr.category == widget.category.name).toList();
    if (creators.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Kahoot! Academy Verified Creators'),
          _horizontalScroll(creators.map((cr) => CreatorCard(creator: cr)).toList(), height: 160),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHashtagsSection() {
    final hashtagGroups = sampleHashtags.where((h) => h.category == widget.category.name).toList();
    if (hashtagGroups.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Hashtags', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
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
          )
        ],
      ),
    );
  }
}