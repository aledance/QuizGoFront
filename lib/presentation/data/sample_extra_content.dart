import 'sample_quizzes.dart';

class Course {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final int activities;
  final int? priceCents;
  final bool accessPass;
  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.activities,
    this.priceCents,
    this.accessPass = false,
  });
}

class Creator {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  Creator({required this.id, required this.name, required this.category, required this.imageUrl});
}

class Channel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Quiz> quizzes;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.quizzes,
  });
}

class HashtagGroup {
  final String tag;
  final String category;
  final List<Quiz> quizzes;
  final String imageUrl;
  HashtagGroup({required this.tag, required this.category, required this.quizzes, required this.imageUrl});
}

final List<Course> sampleCourses = [
  Course(
    id: 'course_math_disney',
    title: 'Aritmética con Disney',
    category: 'Matemáticas',
    imageUrl: 'https://picsum.photos/seed/course_math_disney/800/400',
    activities: 5,
    accessPass: true,
  ),
  Course(
    id: 'course_math_winter',
    title: 'Matemáticas de invierno Disney',
    category: 'Matemáticas',
    imageUrl: 'https://picsum.photos/seed/course_math_winter/800/400',
    activities: 4,
    accessPass: true,
  ),
  Course(
    id: 'course_science_space',
    title: 'Explorando el espacio',
    category: 'Ciencias',
    imageUrl: 'https://picsum.photos/seed/course_science_space/800/400',
    activities: 6,
    priceCents: 6990,
  ),
  Course(
    id: 'course_history_world',
    title: 'Historia universal rápida',
    category: 'Historia universal',
    imageUrl: 'https://picsum.photos/seed/course_history_world/800/400',
    activities: 8,
    priceCents: 5990,
  ),
  Course(
    id: 'course_it_basics',
    title: 'Fundamentos de Informática',
    category: 'Informática',
    imageUrl: 'https://picsum.photos/seed/course_it_basics/800/400',
    activities: 7,
    accessPass: true,
  ),
  Course(
    id: 'course_music_pop',
    title: 'Historia del Pop',
    category: 'Música',
    imageUrl: 'https://picsum.photos/seed/course_music_pop/800/400',
    activities: 5,
    priceCents: 4990,
  ),
];

final List<Creator> sampleCreators = [
  Creator(id: 'creator_math_team', name: 'MathTeam', category: 'Matemáticas', imageUrl: 'https://picsum.photos/seed/creator_math/400/400'),
  Creator(id: 'creator_history_hub', name: 'HistoryHub', category: 'Historia universal', imageUrl: 'https://picsum.photos/seed/creator_history/400/400'),
  Creator(id: 'creator_science_fun', name: 'CienciaFun', category: 'Ciencias', imageUrl: 'https://picsum.photos/seed/creator_science/400/400'),
  Creator(id: 'creator_trivia_master', name: 'TriviaMaster', category: 'Trivia', imageUrl: 'https://picsum.photos/seed/creator_trivia/400/400'),
  Creator(id: 'creator_code_start', name: 'CodeStart', category: 'Informática', imageUrl: 'https://picsum.photos/seed/creator_code/400/400'),
];

final List<Channel> sampleChannels = [
  Channel(
    id: 'nickelodeon',
    name: 'Nickelodeon',
    description: 'Diversión animada para toda la clase',
    imageUrl: 'https://picsum.photos/seed/channel-nick/1200/600',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Películas') || q.categories.contains('Series')).take(3).toList(),
  ),
  Channel(
    id: 'peanuts',
    name: 'Peanuts Español',
    description: 'Aprende con Snoopy y sus amigos',
    imageUrl: 'https://picsum.photos/seed/channel-peanuts/1200/600',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Trivia')).take(3).toList(),
  ),
  Channel(
    id: 'disney',
    name: 'Disney en clase',
    description: 'Historias mágicas para aprender',
    imageUrl: 'https://picsum.photos/seed/channel-disney/1200/600',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Matemáticas')).take(3).toList(),
  ),
  Channel(
    id: 'wikikids',
    name: 'Wiki Kids',
    description: 'Explora curiosidades del mundo',
    imageUrl: 'https://picsum.photos/seed/channel-wiki/1200/600',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Ciencias')).take(3).toList(),
  ),
];

final List<HashtagGroup> sampleHashtags = [
  HashtagGroup(
    tag: 'mates',
    category: 'Matemáticas',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Matemáticas')).take(4).toList(),
    imageUrl: 'https://picsum.photos/seed/hashtag-mates/800/400',
  ),
  HashtagGroup(
    tag: 'math',
    category: 'Matemáticas',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Matemáticas')).skip(2).take(4).toList(),
    imageUrl: 'https://picsum.photos/seed/hashtag-math/800/400',
  ),
  HashtagGroup(
    tag: 'cine',
    category: 'Películas',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Películas')).take(4).toList(),
    imageUrl: 'https://picsum.photos/seed/hashtag-cine/800/400',
  ),
  HashtagGroup(
    tag: 'trivia',
    category: 'Trivia',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Trivia')).take(4).toList(),
    imageUrl: 'https://picsum.photos/seed/hashtag-trivia/800/400',
  ),
  HashtagGroup(
    tag: 'science',
    category: 'Ciencias',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Ciencias')).take(4).toList(),
    imageUrl: 'https://picsum.photos/seed/hashtag-science/800/400',
  ),
  HashtagGroup(
    tag: 'coding',
    category: 'Informática',
    quizzes: sampleQuizzes.where((q) => q.categories.contains('Informática')).take(4).toList(),
    imageUrl: 'https://picsum.photos/seed/hashtag-coding/800/400',
  ),
];

Course courseById(String id) {
  return sampleCourses.firstWhere((c) => c.id == id, orElse: () => sampleCourses.first);
}

String hashtagSlug(String tag) {
  final cleaned = tag.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  return cleaned.replaceAll(RegExp(r'-+'), '-').replaceAll(RegExp(r'^-|-$'), '');
}

HashtagGroup hashtagBySlug(String slug) {
  return sampleHashtags.firstWhere(
    (group) => hashtagSlug(group.tag) == slug,
    orElse: () => sampleHashtags.first,
  );
}