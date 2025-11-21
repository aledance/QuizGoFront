import '../components/categories_grid.dart';

const List<CategoryItem> kDefaultCategories = [
  CategoryItem('Matemáticas', 'https://picsum.photos/seed/cat-math/600/300'),
  CategoryItem('Ciencias', 'https://picsum.photos/seed/cat-science/600/300'),
  CategoryItem('Historia universal', 'https://picsum.photos/seed/cat-history/600/300'),
  CategoryItem('Películas', 'https://picsum.photos/seed/cat-movies/600/300'),
  CategoryItem('Trivia', 'https://picsum.photos/seed/cat-trivia/600/300'),
  CategoryItem('Música', 'https://picsum.photos/seed/cat-music/600/300'),
  CategoryItem('Deportes', 'https://picsum.photos/seed/cat-sports/600/300'),
  CategoryItem('Informática', 'https://picsum.photos/seed/cat-it/600/300'),
];

String slugifyCategory(String name) {
  return name.toLowerCase().replaceAll(RegExp(r'\s+'), '-');
}

String titleFromSlug(String slug) {
  return slug
      .split('-')
      .where((segment) => segment.isNotEmpty)
      .map((segment) => segment[0].toUpperCase() + segment.substring(1))
      .join(' ');
}

CategoryItem categoryFromSlug(String slug) {
  final match = kDefaultCategories.firstWhere(
    (item) => slugifyCategory(item.name) == slug,
    orElse: () => CategoryItem(titleFromSlug(slug), 'https://picsum.photos/seed/$slug/600/300'),
  );
  return match;
}