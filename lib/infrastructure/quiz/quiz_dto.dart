// lib/infrastructure/quiz/quiz_dto.dart
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_application_1/domain/quiz/entities/author.dart' as domain;
import 'package:flutter_application_1/domain/quiz/entities/option.dart' as domain;
import 'package:flutter_application_1/domain/quiz/entities/question.dart' as domain;
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart' as domain;
import 'package:flutter_application_1/domain/quiz/value_objects/image_url.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/option_text.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/play_count.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/question_statement.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_description.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_name.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_theme.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/visibility.dart';

part 'quiz_dto.freezed.dart';
part 'quiz_dto.g.dart';

@freezed
abstract class AuthorDto with _$AuthorDto {
  const AuthorDto._();

  const factory AuthorDto({
    required String id,
    required String name,
  }) = _AuthorDto;

  factory AuthorDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorDtoFromJson(json);

  factory AuthorDto.fromDomain(domain.Author author) {
    return AuthorDto(
      id: author.id.value,
      name: author.name,
    );
  }

  domain.Author toDomain() {
    return domain.Author(
      id: UniqueId.fromUniqueString(id),
      name: name,
    );
  }
}

@freezed
abstract class OptionDto with _$OptionDto {
  const OptionDto._();

  const factory OptionDto({
    required String id,
    required String text,
  }) = _OptionDto;

  factory OptionDto.fromJson(Map<String, dynamic> json) =>
      _$OptionDtoFromJson(json);

  factory OptionDto.fromDomain(domain.Option option) {
    return OptionDto(
      id: option.id.value,
      text: option.text.value,
    );
  }

  domain.Option toDomain() {
    return domain.Option(
      id: UniqueId.fromUniqueString(id),
      text: OptionText(text),
    );
  }
}

@freezed
abstract class QuestionDto with _$QuestionDto {
  const QuestionDto._();

  const factory QuestionDto({
    required String id,
    required String statement,
    required List<OptionDto> options,
    required String correctOptionId,
  }) = _QuestionDto;

  factory QuestionDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionDtoFromJson(json);

  factory QuestionDto.fromDomain(domain.Question question) {
    return QuestionDto(
      id: question.id.value,
      statement: question.statement.value,
      options: question.options.map((o) => OptionDto.fromDomain(o)).toList(),
      correctOptionId: question.correctOption.id.value,
    );
  }

  domain.Question toDomain() {
    final domainOptions = options.map((dto) => dto.toDomain()).toList();
    final correct = domainOptions.firstWhere(
      (o) => o.id.value == correctOptionId,
      orElse: () => domainOptions.isNotEmpty ? domainOptions.first : throw StateError('No options available'),
    );

    return domain.Question(
      id: UniqueId.fromUniqueString(id),
      statement: QuestionStatement(statement),
      options: domainOptions,
      correctOption: correct,
    );
  }
}

@freezed
abstract class QuizDto with _$QuizDto {
  const QuizDto._();

  @JsonSerializable(explicitToJson: true)
  const factory QuizDto({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'kahoot_image_url') String? kahootImageUrl,
    required String visibility,
    List<String>? themes,
    required AuthorDto author,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'play_count') int? playCount,
    required List<QuestionDto> questions,
  }) = _QuizDto;

  factory QuizDto.fromJson(Map<String, dynamic> json) =>
      _$QuizDtoFromJson(json);

  factory QuizDto.fromDomain(domain.Quiz quiz) {
    return QuizDto(
      id: quiz.id.value,
      name: quiz.name.value,
      description: quiz.description.value,
      kahootImageUrl: quiz.kahootImage?.value,
      visibility: quiz.visibility.name,
      themes: quiz.themes?.map((t) => t.value).toList(),
      author: AuthorDto.fromDomain(quiz.author),
      createdAt: quiz.createdAt,
      playCount: quiz.playCount?.value,
      questions: quiz.questions.map((q) => QuestionDto.fromDomain(q)).toList(),
    );
  }

  domain.Quiz toDomain() {
    return domain.Quiz(
      id: UniqueId.fromUniqueString(id),
      name: QuizName(name),
      description: QuizDescription(description ?? ''),
      kahootImage: kahootImageUrl == null ? null : ImageUrl(kahootImageUrl!),
      visibility: Visibility.values.firstWhere((e) => e.name == visibility),
      themes: themes?.map((t) => QuizTheme(t)).toList(),
      author: author.toDomain(),
      createdAt: createdAt,
      playCount: playCount == null ? null : PlayCount(playCount!),
      questions: questions.map((dto) => dto.toDomain()).toList(),
    );
  }
}
