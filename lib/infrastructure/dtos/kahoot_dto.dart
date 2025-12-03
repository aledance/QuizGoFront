import '../../domain/entities/kahoot.dart';
import '../../domain/entities/author.dart';
import 'question_dto.dart';

class KahootDto {
  final String? id;
  final String title;
  final String description;
  final String? coverImageId;
  final String visibility;
  final String? status;
  final String? category;
  final String? themeId;
  final Map<String, dynamic> author;
  final String createdAt;
  final List<QuestionDto> questions;

  KahootDto({
    this.id,
    required this.title,
    required this.description,
    this.coverImageId,
    required this.visibility,
    required this.status,
    required this.category,
    this.themeId,
    required this.author,
    required this.createdAt,
    required this.questions,
  });

  factory KahootDto.fromJson(Map<String, dynamic> json) => KahootDto(
        id: json['id'] as String?,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        coverImageId: json['coverImageId'] as String?,
        visibility: json['visibility'] as String? ?? 'private',
        status: json['status'] as String? ?? 'draft',
        category: json['category'] as String? ?? 'Tecnología',
        themeId: json['themeId'] as String?,
        author: (json['author'] as Map<String, dynamic>?) ?? {},
        createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        questions: (json['questions'] as List<dynamic>? ?? [])
            .map((q) => QuestionDto.fromJson(q as Map<String, dynamic>))
            .toList(),
      );


  Map<String, dynamic> toJsonRequest({required String authorId, required String themeId}) => {
    'authorId': authorId,

    //'author': {'authorId': authorId, 'name': author['name'] ?? ''},
        'title': title,
        'description': description,
        'coverImageId': coverImageId,
        'visibility': visibility,
        'status': status,
        'category': category,
        'themeId': themeId,
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  Kahoot toEntity() => Kahoot(
        id: id,
        title: title,
        description: description,
        coverImageId: coverImageId,
        visibility: visibility,
        status: status,
        category: category,
        themeId: themeId,
        author: Author(authorId: author['authorId'] as String? ?? '', name: author['name'] as String? ?? ''),
        createdAt: DateTime.parse(createdAt),
        questions: questions.map((q) => q.toEntity()).toList(),
      );

  factory KahootDto.fromEntity(Kahoot k) => KahootDto(
        id: k.id,
        title: k.title,
        description: k.description,
        coverImageId: k.coverImageId,
        visibility: k.visibility,
        status: k.status,
        category: k.category,
        themeId: k.themeId,
        author: {'authorId': k.author.authorId, 'name': k.author.name},
        createdAt: k.createdAt.toIso8601String(),
        questions: k.questions.map((q) => QuestionDto.fromEntity(q)).toList(),
      );
}