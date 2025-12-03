import '../../domain/entities/kahoot.dart';
import '../../domain/entities/author.dart';
import 'question_dto.dart';

class KahootDto {
  final String? id;
  final String title;
  final String description;
  final String? coverImageId;
  final String? category;
  final String? status;
  final String visibility;
  final String? themeId;
  final Map<String, dynamic> author;
  final String createdAt;
  final List<QuestionDto> questions;

  KahootDto({
    this.id,
    required this.title,
    required this.description,
    this.coverImageId,
    this.category,
    this.status,
    required this.visibility,
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
        category: json['category'] as String?,
        status: json['status'] as String?,
        visibility: json['visibility'] as String? ?? 'private',
        themeId: json['themeId'] as String?,
        author: (json['author'] as Map<String, dynamic>?) ?? {},
        createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        questions: (json['questions'] as List<dynamic>? ?? [])
            .map((q) => QuestionDto.fromJson(q as Map<String, dynamic>))
            .toList(),
      );


  Map<String, dynamic> toJsonRequest({required String authorId}) => {
    'authorId': authorId,

    'author': {'authorId': authorId, 'name': author['name'] ?? ''},
        'title': title,
        'description': description,
        'coverImageId': coverImageId,
        'category': category,
        'status': status,
        'visibility': visibility,
        'themeId': themeId,
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  Kahoot toEntity() => Kahoot(
        id: id,
        title: title,
        description: description,
        coverImageId: coverImageId,
      category: category,
      status: status,
        visibility: visibility,
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
        category: k.category,
        status: k.status,
      visibility: k.visibility,
        themeId: k.themeId,
        author: {'authorId': k.author.authorId, 'name': k.author.name},
        createdAt: k.createdAt.toIso8601String(),
        questions: k.questions.map((q) => QuestionDto.fromEntity(q)).toList(),
      );
}