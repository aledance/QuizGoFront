import 'package:flutter/material.dart';
import '../data/sample_quizzes.dart';

class FeaturedQuizzesList extends StatefulWidget {
  final List<Quiz> items;
  const FeaturedQuizzesList({super.key, required this.items});

  @override
  State<FeaturedQuizzesList> createState() => _FeaturedQuizzesListState();
}

class _FeaturedQuizzesListState extends State<FeaturedQuizzesList> {
  late final PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _pageController.addListener(_handleScroll);
  }

  void _handleScroll() {
    setState(() {
      _currentPage = _pageController.page ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_handleScroll);
    _pageController.dispose();
    super.dispose();
  }

  List<List<Quiz>> _chunk(List<Quiz> source, int size) {
    final result = <List<Quiz>>[];
    for (var i = 0; i < source.length; i += size) {
      final end = (i + size) > source.length ? source.length : i + size;
      result.add(source.sublist(i, end));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _chunk(widget.items, 3);
    if (pages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text('Más destacados', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 360,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, pageIndex) {
              final group = pages[pageIndex];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    for (var i = 0; i < group.length; i++) ...[
                      _FeaturedRow(quiz: group[i], index: pageIndex * 3 + i + 1),
                      if (i < group.length - 1) const SizedBox(height: 12),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pages.length, (index) {
            final isActive = (index - _currentPage).abs() < 0.5;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FeaturedRow extends StatelessWidget {
  final Quiz quiz;
  final int index;
  const _FeaturedRow({required this.quiz, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              child: Image.network(quiz.imageUrl, width: 120, height: 80, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('#$index', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            quiz.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(quiz.author, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.favorite, size: 16, color: Colors.pinkAccent.withOpacity(0.9)),
                        const SizedBox(width: 4),
                        Text('${quiz.likes}', style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(width: 12),
                        Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(_timeAgo(quiz.createdAt), style: Theme.of(context).textTheme.labelSmall),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 24) {
      return '${diff.inHours}h';
    }
    return '${diff.inDays}d';
  }
}