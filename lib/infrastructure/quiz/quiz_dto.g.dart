// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthorDto _$AuthorDtoFromJson(Map<String, dynamic> json) =>
    _AuthorDto(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$AuthorDtoToJson(_AuthorDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_OptionDto _$OptionDtoFromJson(Map<String, dynamic> json) =>
    _OptionDto(id: json['id'] as String, text: json['text'] as String);

Map<String, dynamic> _$OptionDtoToJson(_OptionDto instance) =>
    <String, dynamic>{'id': instance.id, 'text': instance.text};

_QuestionDto _$QuestionDtoFromJson(Map<String, dynamic> json) => _QuestionDto(
  id: json['id'] as String,
  statement: json['statement'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => OptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  correctOptionId: json['correctOptionId'] as String,
);

Map<String, dynamic> _$QuestionDtoToJson(_QuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statement': instance.statement,
      'options': instance.options,
      'correctOptionId': instance.correctOptionId,
    };

_QuizDto _$QuizDtoFromJson(Map<String, dynamic> json) => _QuizDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  kahootImageUrl: json['kahoot_image_url'] as String?,
  visibility: json['visibility'] as String,
  themes: (json['themes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  author: AuthorDto.fromJson(json['author'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  playCount: (json['play_count'] as num?)?.toInt(),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuestionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizDtoToJson(_QuizDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'kahoot_image_url': instance.kahootImageUrl,
  'visibility': instance.visibility,
  'themes': instance.themes,
  'author': instance.author.toJson(),
  'created_at': instance.createdAt.toIso8601String(),
  'play_count': instance.playCount,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};
