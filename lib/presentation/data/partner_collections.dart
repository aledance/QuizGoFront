import 'sample_extra_content.dart';
import 'sample_quizzes.dart';

class PartnerCollection {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final List<String> categories;
  final List<String> highlightCourseIds;
  final List<String> hashtags;

  const PartnerCollection({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.categories,
    this.highlightCourseIds = const [],
    this.hashtags = const [],
  });
}

const List<PartnerCollection> partnerCollections = [
  PartnerCollection(
    id: 'accesspass',
    name: 'Kahoot!+ AccessPass',
    imageUrl: 'https://picsum.photos/seed/collection-accesspass/1200/600',
    description: 'Biblioteca premium con planes guiados, actividades exclusivas y experiencias Disney para reforzar tus cursos.',
    categories: ['Matemáticas', 'Ciencias', 'Historia universal'],
    highlightCourseIds: ['course_math_disney', 'course_math_winter', 'course_science_space'],
    hashtags: ['mates', 'math'],
  ),
  PartnerCollection(
    id: 'disney',
    name: 'Colección Disney',
    imageUrl: 'https://picsum.photos/seed/collection-disney/1200/600',
    description: 'Explora el universo Disney con kahoots temáticos listos para usar en primaria.',
    categories: ['Matemáticas', 'Películas'],
    highlightCourseIds: ['course_math_disney'],
    hashtags: ['cine'],
  ),
  PartnerCollection(
    id: 'nick',
    name: 'Nickelodeon Kids',
    imageUrl: 'https://picsum.photos/seed/collection-nick/1200/600',
    description: 'Personajes de Nick que acompañan tus lecciones de ciencias y trivia.',
    categories: ['Ciencias', 'Trivia'],
    highlightCourseIds: ['course_science_space'],
    hashtags: ['science', 'trivia'],
  ),
  PartnerCollection(
    id: 'wiki',
    name: 'Wikipedia Edu',
    imageUrl: 'https://picsum.photos/seed/collection-wiki/1200/600',
    description: 'Paquetes basados en artículos revisados para fomentar la investigación.',
    categories: ['Historia universal', 'Informática'],
    highlightCourseIds: ['course_history_world'],
    hashtags: ['science', 'coding'],
  ),
];

PartnerCollection partnerCollectionById(String id) {
  return partnerCollections.firstWhere(
    (collection) => collection.id == id,
    orElse: () => partnerCollections.first,
  );
}

List<Quiz> collectionQuizzes(PartnerCollection collection, {int limit = 8}) {
  final filtered = sampleQuizzes.where(
    (quiz) => quiz.categories.any(collection.categories.contains),
  );
  return filtered.take(limit).toList();
}

List<Course> collectionCourses(PartnerCollection collection) {
  return sampleCourses
      .where((course) => collection.highlightCourseIds.contains(course.id) || collection.categories.contains(course.category))
      .toList();
}