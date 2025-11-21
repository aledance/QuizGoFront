class Quiz {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final int likes;
  final List<String> categories;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.likes,
    required this.categories,
    required this.createdAt,
  });
}



final List<Quiz> sampleQuizzes = [

  Quiz(
    id: 'math1',
    title: 'Álgebra básica',
    author: 'MathTeam',
    imageUrl: 'https://picsum.photos/seed/math1/600/300',
    likes: 120,
    categories: ['Matemáticas'],
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Quiz(
    id: 'math2',
    title: 'Geometría rápida',
    author: 'MathTeam',
    imageUrl: 'https://picsum.photos/seed/math2/600/300',
    likes: 95,
    categories: ['Matemáticas'],
    createdAt: DateTime.now().subtract(const Duration(hours: 15)),
  ),

  Quiz(
    id: 'science1',
    title: 'Células y ADN',
    author: 'CienciaFun',
    imageUrl: 'https://picsum.photos/seed/science1/600/300',
    likes: 140,
    categories: ['Ciencias'],
    createdAt: DateTime.now().subtract(const Duration(hours: 9)),
  ),
  Quiz(
    id: 'science2',
    title: 'Fuerzas y movimiento',
    author: 'PhysicsLab',
    imageUrl: 'https://picsum.photos/seed/science2/600/300',
    likes: 88,
    categories: ['Ciencias'],
    createdAt: DateTime.now().subtract(const Duration(hours: 19)),
  ),

  Quiz(
    id: 'history1',
    title: 'Imperio Romano',
    author: 'HistoryHub',
    imageUrl: 'https://picsum.photos/seed/history1/600/300',
    likes: 112,
    categories: ['Historia universal'],
    createdAt: DateTime.now().subtract(const Duration(hours: 7)),
  ),
  Quiz(
    id: 'history2',
    title: 'Guerras Mundiales',
    author: 'HistoryHub',
    imageUrl: 'https://picsum.photos/seed/history2/600/300',
    likes: 76,
    categories: ['Historia universal'],
    createdAt: DateTime.now().subtract(const Duration(hours: 30)),
  ),

  Quiz(
    id: 'movies1',
    title: 'Clásicos del cine',
    author: 'FilmStudio',
    imageUrl: 'https://picsum.photos/seed/movies1/600/300',
    likes: 150,
    categories: ['Películas'],
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Quiz(
    id: 'movies2',
    title: 'Héroes y villanos',
    author: 'FilmStudio',
    imageUrl: 'https://picsum.photos/seed/movies2/600/300',
    likes: 102,
    categories: ['Películas'],
    createdAt: DateTime.now().subtract(const Duration(hours: 26)),
  ),

  Quiz(
    id: 'trivia1',
    title: 'Trivia general',
    author: 'TriviaMaster',
    imageUrl: 'https://picsum.photos/seed/trivia1/600/300',
    likes: 200,
    categories: ['Trivia'],
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  Quiz(
    id: 'trivia2',
    title: '¿Sabías que...?',
    author: 'TriviaMaster',
    imageUrl: 'https://picsum.photos/seed/trivia2/600/300',
    likes: 132,
    categories: ['Trivia'],
    createdAt: DateTime.now().subtract(const Duration(hours: 20)),
  ),

  Quiz(
    id: 'music1',
    title: 'Hits Pop 2025',
    author: 'PopStudio',
    imageUrl: 'https://picsum.photos/seed/music1/600/300',
    likes: 180,
    categories: ['Música'],
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
  ),
  Quiz(
    id: 'music2',
    title: 'Rock clásico',
    author: 'PopStudio',
    imageUrl: 'https://picsum.photos/seed/music2/600/300',
    likes: 121,
    categories: ['Música'],
    createdAt: DateTime.now().subtract(const Duration(hours: 24)),
  ),

  Quiz(
    id: 'sports1',
    title: 'Fútbol internacional',
    author: 'SportsZone',
    imageUrl: 'https://picsum.photos/seed/sports1/600/300',
    likes: 170,
    categories: ['Deportes'],
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Quiz(
    id: 'sports2',
    title: 'Olimpiadas',
    author: 'SportsZone',
    imageUrl: 'https://picsum.photos/seed/sports2/600/300',
    likes: 98,
    categories: ['Deportes'],
    createdAt: DateTime.now().subtract(const Duration(hours: 33)),
  ),

  Quiz(
    id: 'it1',
    title: 'Conceptos básicos de programación',
    author: 'CodeStart',
    imageUrl: 'https://picsum.photos/seed/it1/600/300',
    likes: 160,
    categories: ['Informática'],
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  Quiz(
    id: 'it2',
    title: 'Ciberseguridad esencial',
    author: 'CodeStart',
    imageUrl: 'https://picsum.photos/seed/it2/600/300',
    likes: 110,
    categories: ['Informática'],
    createdAt: DateTime.now().subtract(const Duration(hours: 28)),
  ),

  Quiz(
    id: 'eco1',
    title: 'Ecología y ambiente',
    author: 'EcoGuard',
    imageUrl: 'https://picsum.photos/seed/eco1/600/300',
    likes: 129,
    categories: ['Ciencias'],
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  Quiz(
    id: 'cineTrivia',
    title: 'Trivia de películas',
    author: 'FilmStudio',
    imageUrl: 'https://picsum.photos/seed/cinetrivia/600/300',
    likes: 145,
    categories: ['Películas', 'Trivia'],
    createdAt: DateTime.now().subtract(const Duration(hours: 10)),
  ),
];


final List<Quiz> newestQuizzes = (List<Quiz>.from(sampleQuizzes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)))
    .take(6)
    .toList();


final List<Quiz> featuredQuizzes = (List<Quiz>.from(sampleQuizzes)
      ..sort((a, b) => b.likes.compareTo(a.likes)))
    .take(9)
    .toList();