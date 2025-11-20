import 'package:flutter/material.dart';
import '../admin/pages/admin_dashboard_page.dart';
import '../components/categories_grid.dart';
import '../components/channel_cards_carousel.dart';
import '../components/course_card.dart';
import '../components/featured_quizzes_list.dart';
import '../components/filter_chips.dart';
import '../components/hashtag_card.dart';
import '../components/partner_collections_section.dart';
import '../components/quiz_card.dart';
import '../components/search_bar.dart';
import '../components/trending_section.dart';
import '../data/categories_data.dart';
import '../data/sample_extra_content.dart';
import '../data/sample_quizzes.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Quiz> visible = sampleQuizzes;
  String query = '';
  List<String> selectedCategories = [];
  bool _searchFocused = false;

  final List<CategoryItem> _categoryItems = kDefaultCategories;

  void _applyFilters() {
    setState(() {
      visible = sampleQuizzes.where((q) {
        bool matchesQuery = query.isEmpty || q.title.toLowerCase().contains(query.toLowerCase()) || q.author.toLowerCase().contains(query.toLowerCase());

        if (!matchesQuery && query.isNotEmpty) {
          matchesQuery = q.categories.any((c) => c.toLowerCase() == query.toLowerCase());
        }
        final matchesCategory = selectedCategories.isEmpty || q.categories.any((c) => selectedCategories.contains(c));
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>{};
    for (final q in sampleQuizzes) {
      categories.addAll(q.categories);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 76,
        titleSpacing: 0,
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4B00B4), Color(0xFF8A2BFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Descubre',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Admin',
                icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          AppSearchBar(
            onChanged: (s) {
              query = s;
              _applyFilters();
            },
            onFocusChanged: (focused) {
              setState(() => _searchFocused = focused);
            },
            onClear: () {
              query = '';
              _applyFilters();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchFocused) ...[
                    if (query.isEmpty) ...[
                      CategoriesGrid(
                        items: _categoryItems,
                        onTap: (cat) {
                          final routeName = '/categoria/${slugifyCategory(cat.name)}';
                          Navigator.of(context).pushNamed(
                            routeName,
                            arguments: cat,
                          );
                        },
                      ),
                    ] else ...[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Text('Resultados', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      _resultsGrid(),
                    ]
                  ] else ...[
                    TrendingSection(items: newestQuizzes, title: 'Kahoots más nuevos'),
                    const PartnerCollectionsSection(),
                    const ChannelCardsCarousel(),
                    _randomCoursesSection(),
                    _randomHashtagsSection(),
                    FeaturedQuizzesList(items: featuredQuizzes),
                    FilterChips(options: categories.toList(), onSelectionChanged: (sel) {
                      selectedCategories = sel;
                      _applyFilters();
                    }),

                  ],
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}

Widget _resultsGridBuilder(List<Quiz> items, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final q = items[index];
        return QuizCard(quiz: q, compact: true);
      },
    ),
  );
}

extension _ResultsGridExt on _ExplorePageState {
  Widget _resultsGrid() => _resultsGridBuilder(visible, context);
}

extension _ExploreExtraSections on _ExplorePageState {
  Widget _randomCoursesSection() {
    final courses = List<Course>.from(sampleCourses)..shuffle();
    final pick = courses.take(3).toList();
    if (pick.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Cursos disponibles', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) => CourseCard(
              course: pick[i],
              onTap: () => Navigator.of(context).pushNamed('/curso/${pick[i].id}', arguments: pick[i]),
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: pick.length,
          ),
        ),
      ],
    );
  }

  Widget _randomHashtagsSection() {
    final tags = List<HashtagGroup>.from(sampleHashtags)..shuffle();
    final pick = tags.take(4).toList();
    if (pick.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Explora hashtags', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) {
              final group = pick[i];
              return HashtagCard(
                group: group,
                onTap: () {
                  final slug = hashtagSlug(group.tag);
                  Navigator.of(context).pushNamed('/hashtag/$slug', arguments: group);
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: pick.length,
          ),
        ),
      ],
    );
  }
}

 